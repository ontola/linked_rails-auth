# frozen_string_literal: true

module LinkedRails
  module Auth
    class PasswordActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.password_class
      end

      has_singular_create_action(
        type: [Vocab::ONTOLA['Create::Auth::Password'], RDF::Vocab::SCHEMA.CreateAction]
      )

      has_singular_update_action(
        label: nil,
        root_relative_iri: lambda {
          RDF::URI(
            path: '/u/password/edit',
            query: {reset_password_token: resource.reset_password_token}.compact.to_param.presence
          )
        }
      )
    end
  end
end
