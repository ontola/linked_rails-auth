# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretsController < LinkedRails.controller_parent_class
      active_response :show

      private

      def create_success
        active_response_block do
          sign_in(current_resource.owner, otp_verified: true) if current_user.guest?

          respond_with_redirect(
            location: current_resource.redirect_url,
            reload: true
          )
        end
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

      class << self
        def controller_class
          LinkedRails.otp_secret_class
        end
      end
    end
  end
end
