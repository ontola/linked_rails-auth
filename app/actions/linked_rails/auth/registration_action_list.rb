# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.registration_class
      end

      has_action(
        :create,
        create_options.merge(
          collection: false,
          include_object: true,
          form: LinkedRails.registration_form_class,
          object: nil,
          policy: :create?,
          root_relative_iri: '/users/sign_up',
          url: -> { LinkedRails.iri(path: '/users') }
        )
      )
    end
  end
end
