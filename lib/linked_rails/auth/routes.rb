# frozen_string_literal: true

module LinkedRails
  module Auth
    module Routes
      DOORKEEPER_CONTROLLERS = %i[applications authorizations authorized_applications token_info tokens].freeze
      DEVISE_CONTROLLERS = %i[confirmations omniauth_callbacks passwords registrations unlocks].freeze
      LINKED_RAILS_CONTROLLERS = {
        confirmations: 'linked_rails/auth/confirmations',
        passwords: 'linked_rails/auth/passwords',
        registrations: 'linked_rails/auth/registrations',
        sessions: 'linked_rails/auth/sessions',
        tokens: 'linked_rails/auth/access_tokens',
        unlocks: 'linked_rails/auth/unlocks'
      }.freeze

      def use_linked_rails_auth(opts = {}) # rubocop:disable Metrics/MethodLength
        sessions_controller = opts[:sessions] || LINKED_RAILS_CONTROLLERS[:sessions]
        tokens_controller = opts[:tokens] || LINKED_RAILS_CONTROLLERS[:tokens]
        confirmations_controller = opts[:confirmations] || LINKED_RAILS_CONTROLLERS[:confirmations]

        linked_rails_doorkeeper_routes(opts)
        linked_rails_device_routes(opts, confirmations_controller)

        scope 'u' do
          post 'sessions', to: "#{sessions_controller}#create"
          get 'sign_in', to: "#{sessions_controller}#new"
          get 'sign_out', to: "#{sessions_controller}#destroy"
          delete 'sign_out', to: "#{sessions_controller}#destroy"
          get 'access_tokens/new', to: "#{tokens_controller}#new"
        end
      end

      private

      def linked_rails_device_routes(opts, confirmations_controller)
        devise_controllers = DEVISE_CONTROLLERS.map do |controller|
          if opts.key?(controller)
            [controller, opts[controller]]
          elsif LINKED_RAILS_CONTROLLERS.key?(controller.to_sym)
            [controller, LINKED_RAILS_CONTROLLERS[controller]]
          end
        end.compact

        devise_for opts[:devise_scope] || :users, path: :users, controllers: Hash[devise_controllers], skip: :sessions

        devise_scope opts[:devise_scope] || :users do
          put 'users/confirmation', to: "#{confirmations_controller}#update"
        end
      end

      def linked_rails_doorkeeper_routes(opts)
        use_doorkeeper do
          DOORKEEPER_CONTROLLERS.each do |controller|
            if opts.key?(controller)
              controllers(controller => opts[controller])
            elsif LINKED_RAILS_CONTROLLERS.key?(controller.to_sym)
              controllers(controller => LINKED_RAILS_CONTROLLERS[controller])
            end
          end
        end
      end
    end
  end
end
ActionDispatch::Routing::Mapper.include LinkedRails::Auth::Routes
