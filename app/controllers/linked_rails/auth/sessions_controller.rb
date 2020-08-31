# frozen_string_literal: true

module LinkedRails
  module Auth
    class SessionsController < ApplicationController
      active_response :new, :create

      private

      def active_response_success_message; end

      def create_execute
        true
      end

      def create_success_location
        if LinkedRails.user_class.find_for_database_authentication(email: permit_params[:email])
          LinkedRails.iri(path: 'u/access_tokens/new').to_s
        else
          LinkedRails.iri(path: 'users/sign_up').to_s
        end
      end

      def new_resource_params
        params.permit(:redirect_url)
      end

      def permit_params
        params.require(:session).permit(:redirect_url, :email)
      end

      def r_param
        new_resource_params[:redirect_url] || (params.key?(:session) ? permit_params[:redirect_url] : nil)
      end

      class << self
        def controller_class
          LinkedRails.session_class
        end
      end
    end
  end
end
