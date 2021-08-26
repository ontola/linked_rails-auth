# frozen_string_literal: true

module LinkedRails
  module Auth
    # rubocop:disable Layout/LineLength
    class RegistrationPolicy < Pundit::PolicyFinder.new(LinkedRails.user_class).policy || LinkedRails.policy_parent_class
      # rubocop:enable Layout/LineLength
      permit_attributes %i[email password password_confirmation redirect_url]

      def create?
        true
      end
    end
  end
end
