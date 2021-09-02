# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptsController < LinkedRails.controller_parent_class
      controller_class LinkedRails.otp_attempt_class
      has_singular_create_action(
        type: Vocab.schema[:CreateAction]
      )

      private

      def create_success
        sign_in(current_resource.owner, otp_verified: true)

        head 200
      end
    end
  end
end
