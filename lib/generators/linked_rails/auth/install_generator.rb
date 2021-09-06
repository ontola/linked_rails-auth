# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module LinkedRails
  module Auth
    class InstallGenerator < ::Rails::Generators::Base # rubocop:disable Metrics/ClassLength
      include ::Rails::Generators::Migration
      source_root File.expand_path('templates', __dir__)
      desc 'Installs LinkedRails Auth.'

      def install # rubocop:disable Metrics/MethodLength
        template 'doorkeeper_jwt_initializer.rb', 'config/initializers/doorkeeper_jwt.rb'
        template 'locales.yml', 'config/locales/linked_rails_auth.en.yml'
        route 'use_linked_rails_auth'

        migration_template(
          'migration.rb.erb',
          'db/migrate/install_linked_rails_auth.rb',
          migration_version: migration_version
        )
        update_user_model
        insert_doorkeeper
        create_doorkeeper_app
        inject_controller_include

        readme 'README'
      end

      private

      def create_doorkeeper_app # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        if Doorkeeper::Application.any?
          Rails.logger.info('Skipping Doorkeeper app creation, already exists')

          return
        end
        client_id = ask('Enter the client_id of your doorkeeper app', default: 'client_id')
        client_secret = ask('Enter the client_secret of your doorkeeper app', default: 'client_secret')
        client_token = ask('Enter the client_token of your doorkeeper app. Leave empty to create new.')

        libro_app = Doorkeeper::Application.find_or_initialize_by(uid: client_id) do |app|
          app.name = 'Libro'
          app.redirect_uri = 'http://example.com/'
          app.scopes = 'guest user'
          app.secret = client_secret
        end
        libro_app.save!(validate: false)
        # rubocop:disable Rails/SkipsModelValidations
        libro_app.update_columns(uid: client_id, secret: client_secret)
        # rubocop:enable Rails/SkipsModelValidations

        ActiveRecord::Base.connection.try(:reset_pk_sequence!, Doorkeeper::Application.table_name)

        token = Doorkeeper::AccessToken.find_or_create_for(
          application: libro_app,
          scopes: 'service',
          expires_in: 10.years.to_i,
          resource_owner: nil,
          use_refresh_token: true
        )

        if client_token.present?
          token.update(token: client_token)
        else
          Rails.logger.info("Generated client token: #{token.token}")
        end
      end

      def insert_doorkeeper # rubocop:disable Metrics/MethodLength
        file = 'config/initializers/doorkeeper.rb'
        data = "api_only\n"\
          "base_controller 'ApplicationController'\n"\
          "base_metal_controller 'ApplicationController'\n"
        inject_into_file file, optimize_indentation(data, 2), after: "orm :active_record\n", verbose: false
        uncomment_lines file, "access_token_generator '::Doorkeeper::JWT'"
        uncomment_lines file, 'use_refresh_token'

        replace_doorkeeper_line(
          'default_scopes  :public',
          '  default_scopes :guest'
        )
        replace_doorkeeper_line(
          'optional_scopes :write, :update',
          '  optional_scopes :user'
        )
        replace_doorkeeper_line(
          'grant_flows %w\[authorization_code client_credentials\]',
          '  grant_flows %w[client_credentials authorization_code password]'
        )
        replace_doorkeeper_line("resource_owner_authenticator do\n(.*?)end\n", authentication, true)
      end

      def authentication
        <<-FOO
  resource_owner_authenticator do
    if doorkeeper_token&.acceptable?('user')
      User.find_by(id: doorkeeper_token.resource_owner_id)
    elsif doorkeeper_token&.acceptable?('guest') && doorkeeper_token_payload['user']
      LinkedRails.guest_user_class.new(id: doorkeeper_token.resource_owner_id)
    end
  end

  resource_owner_from_credentials do
    request.params[:user] = request.params[:access_token] || {}
    request.params[:user][:email] ||= (request.params[:username] || request.params[:email])&.downcase
    request.params[:user][:password] ||= request.params[:token] || request.params[:password]
    request.env['devise.allow_params_authentication'] = true
    user =
      if request.params[:scope] == 'guest'
        LinkedRails.guest_user_class.new
      else
        request.env['warden'].authenticate(scope: :user, store: false)
      end
    raise_login_error(request) if user.blank?
    request.env['warden'].logout
    user
  end
        FOO
      end

      def inject_controller_include
        sentinel = /LinkedRails::Controller\n/m
        in_root do
          inject_into_file(
            'app/controllers/application_controller.rb',
            optimize_indentation('include LinkedRails::Auth::AuthHelper', 2),
            after: sentinel
          )
        end
      end

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end

      def replace_doorkeeper_line(old, new, multi_line_sentinel = false)
        sentinel = multi_line_sentinel ? /^(\s*)#{old}/m : /^(\s*)#[[:blank:]]*(.*#{old})/
        gsub_file('config/initializers/doorkeeper.rb', sentinel, new)
      end

      def update_user_model
        file = 'app/models/user.rb'
        no_guest = "\ndef guest?\n  false\nend"
        inject_into_file(
          file,
          optimize_indentation(no_guest, 2),
          after: ":recoverable, :rememberable, :validatable\n",
          verbose: false
        )
      end

      class << self
        def next_migration_number(dirname)
          ActiveRecord::Generators::Base.next_migration_number(dirname)
        end
      end
    end
  end
end
