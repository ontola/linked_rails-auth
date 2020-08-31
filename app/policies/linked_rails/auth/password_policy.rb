# frozen_string_literal: true

module LinkedRails
  module Auth
    class PasswordPolicy < LinkedRails.policy_parent_class
      permit_attributes %i[password password_confirmation reset_password_token],
                        has_properties: {reset_password_token: true}
      permit_attributes %i[email], has_properties: {reset_password_token: false}

      def create?
        true
      end

      def update?
        true
      end
    end
  end
end
