# frozen_string_literal: true

module LinkedRails
  module Auth
    class UnlocksController < Devise::UnlocksController
      controller_class LinkedRails.unlock_class
      has_singular_create_action(
        form: -> { resource.class.try(:form_class) }
      )
      has_singular_update_action

      private

      def after_sending_unlock_instructions_path_for(_resource)
        LinkedRails.iri(path: '/u/session/new').path
      end

      def after_unlock_path_for(_resource)
        LinkedRails.iri(path: '/u/session/new').path
      end

      def create_execute
        @current_resource = resource_class.send_unlock_instructions(resource_params)

        successfully_sent?(current_resource!)
      end

      def create_failure_message; end

      def create_success_location
        after_sending_unlock_instructions_path_for(current_resource)
      end

      def create_success_message
        find_message(:send_instructions)
      end

      def resource_params
        params.fetch(resource_name, nil) ||
          params.fetch(controller_name.singularize, {})
      end
    end
  end
end
