# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptsController < LinkedRails.controller_parent_class
      private

      def create_success
        sign_in(current_resource.user, otp_verified: true)

        head 200
      end
    end
  end
end
