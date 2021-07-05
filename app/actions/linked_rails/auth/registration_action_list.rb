# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.registration_class
      end

      has_singular_create_action(
        root_relative_iri: '/u/registration/new'
      )
    end
  end
end
