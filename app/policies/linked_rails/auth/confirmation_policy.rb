# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationPolicy < LinkedRails.policy_parent_class
      permit_attributes %i[email]

      def create?
        true
      end

      def show?
        true
      end
    end
  end
end
