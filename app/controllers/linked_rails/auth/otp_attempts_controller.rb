# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptsController < LinkedRails.controller_parent_class
      private

      def create_success
        sign_in(current_resource.owner, otp_verified: true)

        head 200
      end

      class << self
        def controller_class
          LinkedRails.otp_attempt_class
        end
      end
    end
  end
end
