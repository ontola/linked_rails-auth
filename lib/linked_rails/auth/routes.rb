# frozen_string_literal: true

module LinkedRails
  module Auth
    module Routes
      DOORKEEPER_CONTROLLERS = {
        access_tokens: :tokens,
        applications: :applications,
        authorizations: :authorizations,
        authorized_applications: :authorized_applications,
        token_info: :token_info
      }.freeze
      DEVISE_CONTROLLERS = %i[omniauth_callbacks].freeze
      LINKED_RAILS_CONTROLLERS = {
        access_tokens: 'linked_rails/auth/access_tokens',
        confirmations: 'linked_rails/auth/confirmations',
        otp_attempts: 'linked_rails/auth/otp_attempts',
        otp_secrets: 'linked_rails/auth/otp_secrets',
        passwords: 'linked_rails/auth/passwords',
        registrations: 'linked_rails/auth/registrations',
        sessions: 'linked_rails/auth/sessions',
        unlocks: 'linked_rails/auth/unlocks'
      }.freeze

      def use_linked_rails_auth(opts = {}) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        linked_rails_doorkeeper_routes(opts)
        linked_rails_device_routes(opts)

        scope 'u' do
          get 'sign_in', to: redirect('/u/session/new')
        end
        devise_scope :user do
          auth_resource(AccessToken, opts)
          auth_resource(Confirmation, opts)
          auth_resource(OtpAttempt, opts)
          auth_resource(OtpSecret, opts)
          linked_resource(
            OtpSecret,
            controller: opts[:otp_secrets] || LINKED_RAILS_CONTROLLERS[:otp_secrets],
            nested: false
          )
          auth_resource(Password, opts)
          auth_resource(Registration, opts)
          auth_resource(Session, opts)
          auth_resource(Unlock, opts)
        end
      end

      private

      def auth_resource(klass, opts)
        key = klass.name.demodulize.tableize.to_sym

        singular_linked_resource(
          klass,
          controller: opts[key] || LINKED_RAILS_CONTROLLERS[key],
          nested: false
        )
      end

      def linked_rails_device_routes(opts)
        devise_for(
          opts[:devise_scope] || :users,
          path: :u,
          controllers: {
            omniauth_callbacks: opts[:omniauth_callbacks]
          },
          only: %i[omniauth_callbacks]
        )
      end

      def linked_rails_doorkeeper_routes(opts)
        use_doorkeeper do
          DOORKEEPER_CONTROLLERS.each do |linked_rails_key, doorkeeper_key|
            if opts.key?(linked_rails_key)
              controllers(doorkeeper_key => opts[linked_rails_key])
            elsif LINKED_RAILS_CONTROLLERS.key?(linked_rails_key)
              controllers(doorkeeper_key => LINKED_RAILS_CONTROLLERS[linked_rails_key])
            end
          end
        end
      end
    end
  end
end
ActionDispatch::Routing::Mapper.include LinkedRails::Auth::Routes
