# frozen_string_literal: true

module LinkedRails
  module Auth
    class UnlockPolicy < LinkedRails.policy_parent_class
      permit_attributes %i[email]

      def create?
        true
      end

      def update?
        true
      end
    end
  end
end
