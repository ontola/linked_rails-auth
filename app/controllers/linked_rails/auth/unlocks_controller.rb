# frozen_string_literal: true

module LinkedRails
  module Auth
    class UnlocksController < Devise::UnlocksController
      active_response :new

      private

      def after_sending_unlock_instructions_path_for(_resource)
        LinkedRails.iri(path: '/u/sign_in').path
      end

      def create_execute
        self.resource = resource_class.send_unlock_instructions(resource_params)
      end

      def create_success_location
        after_sending_unlock_instructions_path_for(resource)
      end

      def create_success_message
        find_message(:send_instructions)
      end

      def new_execute
        self.resource = resource_class.new
      end

      def resource_params
        params.fetch(resource_name, nil) ||
          params.fetch(controller_name.singularize, {})
      end
    end
  end
end
