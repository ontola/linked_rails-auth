# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretsController < LinkedRails.controller_parent_class
      include OtpHelper

      private

      def create_success
        active_response_block do
          sign_in(current_resource.user, otp_verified: true) if current_user.guest?

          respond_with_redirect(
            location: session_from_param['redirect_uri'] || LinkedRails.iri.to_s,
            reload: true
          )
        end
      end

      def current_resource
        return super if %w[delete destroy].include?(action_name) && params.key?(:id)

        @current_resource ||= secret_for_user_id(
          user_id_from_session || (current_user.guest? ? raise(ActiveRecord::RecordNotFound) : current_user.id)
        )
      end

      def secret_for_user_id(user_id)
        secret = LinkedRails.otp_secret_class.find_or_create_by!(user_id: user_id)
        secret.session = session_param if params[:session]
        secret
      end

      def delete_success_options
        super.merge(
          meta: [
            RDF::Statement.new(
              LinkedRails.iri(path: '/u/otp_secrets/delete'),
              RDF::OWL.sameAs,
              LinkedRails.iri(path: "#{current_resource.iri.path}/delete"),
            )
          ]
        )
      end

      def destroy_success
        active_response_block do
          respond_with_redirect(location: LinkedRails.iri.to_s, reload: true)
        end
      end

      def permit_params
        return super unless action_name == 'create'

        super.merge(active: true)
      end
    end
  end
end
