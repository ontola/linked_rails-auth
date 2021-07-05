# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :assert_is_devise_resource!, only: :show
      active_response :show

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

      class << self
        def controller_class
          LinkedRails.registration_class
        end
      end
    end
  end
end
