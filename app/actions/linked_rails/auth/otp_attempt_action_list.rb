# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.otp_attempt_class
      end

      has_singular_create_action(type: Vocab.schema[:CreateAction])
    end
  end
end
