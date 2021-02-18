# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptPolicy < LinkedRails.policy_parent_class
      permit_attributes %i[otp_attempt]

      def show?
        user.guest?
      end

      def create?
        user.guest? && record.active?
      end
    end
  end
end
