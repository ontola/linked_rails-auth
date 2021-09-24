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

      def use_linked_rails_auth(**opts) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        linked_rails_doorkeeper_routes(**opts)
        linked_rails_device_routes(**opts)

        scope 'u' do
          get 'sign_in', to: redirect('/u/session/new')
        end
        devise_scope :user do
          auth_resource(LinkedRails.access_token_class, **opts)
          auth_resource(LinkedRails.confirmation_class, **opts)
          auth_resource(LinkedRails.otp_attempt_class, **opts)
          auth_resource(LinkedRails.otp_secret_class, **opts)
          linked_resource(
            LinkedRails.otp_secret_class,
            controller: opts[:otp_secrets] || LINKED_RAILS_CONTROLLERS[:otp_secrets]
          )
          auth_resource(LinkedRails.password_class, **opts)
          auth_resource(LinkedRails.registration_class, **opts)
          auth_resource(LinkedRails.session_class, **opts)
          auth_resource(LinkedRails.unlock_class, **opts)
        end
      end

      private

      def auth_resource(klass, **opts)
        key = klass.name.demodulize.tableize.to_sym

        singular_linked_resource(
          klass,
          controller: opts[key] || LINKED_RAILS_CONTROLLERS[key]
        )
      end

      def linked_rails_device_routes(**opts)
        devise_for(
          opts[:devise_scope] || :users,
          path: :u,
          controllers: {
            omniauth_callbacks: opts[:omniauth_callbacks]
          },
          only: %i[omniauth_callbacks]
        )
      end

      def linked_rails_doorkeeper_routes(**opts)
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
