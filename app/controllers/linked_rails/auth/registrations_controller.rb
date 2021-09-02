# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationsController < Devise::RegistrationsController
      include LinkedRails::Controller

      skip_before_action :assert_is_devise_resource!, only: :show

      controller_class LinkedRails.registration_class
      active_response :show
      has_singular_create_action

      private

      def active_response_success_message; end

      def create_success
        sign_in(current_resource)
        super
      end

      def create_success_location
        current_resource.redirect_url
      end

      def resource_params
        params.require(permit_param_key)
      end
    end
  end
end
