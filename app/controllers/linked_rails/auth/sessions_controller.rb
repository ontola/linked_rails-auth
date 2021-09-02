# frozen_string_literal: true

module LinkedRails
  module Auth
    class SessionsController < LinkedRails.controller_parent_class
      controller_class LinkedRails.session_class
      has_singular_create_action(
        type: [Vocab.ontola['Create::Auth::Session'], Vocab.schema.CreateAction]
      )

      private

      def active_response_success_message; end

      def active_response_failure_message; end

      def create_execute
        true
      end

      def create_success_location
        if requested_user
          LinkedRails.iri(path: 'u/access_token/new').to_s
        else
          LinkedRails.iri(path: 'u/registration/new').to_s
        end
      end

      def requested_user
        @requested_user ||= LinkedRails.user_class.find_for_database_authentication(email: permit_params[:email])
      end

      def destroy_execute
        sign_out
      end

      def destroy_success
        respond_with_redirect(
          location: '/'
        )
      end

      def permit_params
        params.require(:session).permit(:redirect_url, :email)
      end

      def r_param
        new_resource_params[:redirect_url] || (params.key?(:session) ? permit_params[:redirect_url] : nil)
      end
    end
  end
end
