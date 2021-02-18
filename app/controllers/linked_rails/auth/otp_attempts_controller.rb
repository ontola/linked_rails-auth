# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptsController < LinkedRails.controller_parent_class
      include OtpHelper

      private

      def create_success
        sign_in(current_resource.user, otp_verified: true)

        head 200
      end

      def new_resource
        attempt = LinkedRails.otp_attempt_class.find_by(user_id: user_id_from_session!) ||
          LinkedRails.otp_attempt_class.new
        attempt&.session = session_param
        attempt
      end
    end
  end
end
