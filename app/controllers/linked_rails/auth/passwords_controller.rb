# frozen_string_literal: true

module LinkedRails
  module Auth
    class PasswordsController < Devise::PasswordsController
      include AuthHelper

      skip_before_action :require_no_authentication, only: :create
      active_response :new, :edit

      private

      def after_sending_reset_password_instructions_path_for(_resource_name)
        LinkedRails.iri(path: '/u/sign_in').path
      end

      def after_resetting_password_path_for(_resource)
        LinkedRails.iri(path: '/u/sign_in').path
      end

      def create_execute
        self.resource = resource_class.send_reset_password_instructions(resource_params)
        @current_resource = resource
        successfully_sent?(resource)
      end

      def create_success_location
        after_sending_reset_password_instructions_path_for(resource_name)
      end

      def create_success_message
        find_message(:send_instructions)
      end

      def current_resource
        @current_resource ||= LinkedRails.password_class.new(
          user: current_user,
          reset_password_token: params[:reset_password_token]
        )
      end

      def edit_execute
        self.resource = resource_class.new
        set_minimum_password_length
        resource.reset_password_token = params[:reset_password_token]
      end

      def new_execute
        self.resource = resource_class.new
      end

      def resource_params
        params.fetch(resource_name, nil) ||
          params.fetch(controller_name.singularize, {})
      end

      def update_execute
        self.resource = resource_class.reset_password_by_token(resource_params)
        @current_resource = resource

        resource.errors.empty?
      end

      def update_success_message
        find_message(:updated_not_active)
      end

      def update_success_location
        after_resetting_password_path_for(resource)
      end

      class << self
        def controller_class
          LinkedRails.password_class
        end
      end
    end
  end
end
