# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretPolicy < LinkedRails.policy_parent_class
      permit_attributes %i[otp_attempt]

      def show?
        user_context.guest? || current_user? || administrate_otp?
      end

      def create?
        return forbid_with_message(I18n.t('actions.otp_secrets.errors.already_exists')) if user_context.otp_active?

        user_context.guest? || current_user?
      end

      def destroy?
        raise(ActiveRecord::RecordNotFound) unless administrate_otp? || current_user?

        return forbid_with_message(I18n.t('actions.otp_secrets.errors.not_activated')) unless record.active?

        current_user? || administrate_otp?
      end

      private

      def current_user?
        record.owner_id == user_context.id
      end

      def administrate_otp?
        false
      end
    end
  end
end
