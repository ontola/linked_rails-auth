# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationPolicy < Pundit::PolicyFinder.new(LinkedRails.user_class).policy
      def create?
        true
      end
    end
  end
end
