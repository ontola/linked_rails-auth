# frozen_string_literal: true

module LinkedRails
  module Auth
    class PasswordsController < Devise::PasswordsController
      skip_before_action :require_no_authentication, only: :create

      private

      def after_sending_reset_password_instructions_path_for(_resource_name)
        LinkedRails.iri(path: '/u/session/new').path
      end

      def after_resetting_password_path_for(_resource)
        LinkedRails.iri(path: '/u/session/new').path
      end

      def create_execute
        @current_resource = resource_class.send_reset_password_instructions(resource_params)
        successfully_sent?(current_resource)
      end

      def create_failure_message; end

      def create_success_location
        after_sending_reset_password_instructions_path_for(resource_name)
      end

      def create_success_message
        find_message(:send_instructions)
      end

      def new_session_path(*_args)
        LinkedRails.iri(path: 'u/session/new').path
      end

      def resource_params
        params.fetch(resource_name, nil) ||
          params.fetch(controller_name.singularize, {})
      end

      def update_execute
        @current_resource = resource_class.reset_password_by_token(resource_params)

        current_resource.errors.empty?
      end

      def update_success_message
        find_message(:updated_not_active)
      end

      def update_success_location
        after_resetting_password_path_for(current_resource)
      end

      class << self
        def controller_class
          LinkedRails.password_class
        end
      end
    end
  end
end
