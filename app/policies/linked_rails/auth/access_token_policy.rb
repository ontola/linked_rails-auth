# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessTokenPolicy < LinkedRails.policy_parent_class
      permit_attributes %i[email password redirect_url]

      def create?
        true
      end
    end
  end
end
