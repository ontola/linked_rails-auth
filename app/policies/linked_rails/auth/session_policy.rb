# frozen_string_literal: true

module LinkedRails
  module Auth
    class SessionPolicy < LinkedRails.policy_parent_class
      permit_attributes %i[email redirect_url]

      def create?
        true
      end

      def show?
        true
      end
    end
  end
end
