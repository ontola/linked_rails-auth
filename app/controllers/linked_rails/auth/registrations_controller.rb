# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationsController < Devise::RegistrationsController
      include AuthHelper
      skip_before_action :assert_is_devise_resource!, only: :show
      before_action :configure_permitted_parameters, only: :create
      active_response :show

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: permit_param_keys)
      end

      private

      def active_response_success_message; end

      def create_success
        super
        sign_in(current_resource)
      end

      def create_success_location
        current_resource.redirect_url
      end

      def index_collection; end

      def new_resource
        return super unless action_name == 'create'

        build_resource
      end

      class << self
        def controller_class
          LinkedRails.registration_class
        end
      end
    end
  end
end
