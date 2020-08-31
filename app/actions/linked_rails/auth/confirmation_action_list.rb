# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.confirmation_class
      end

      has_action(
        :create,
        create_options.merge(
          collection: false,
          include_object: true,
          object: nil,
          policy: :create?,
          url: -> { LinkedRails.iri(path: '/users/confirmation') },
          type: [Vocab::ONTOLA['Create::Auth::Confirmation'], RDF::Vocab::SCHEMA.CreateAction]
        )
      )
    end
  end
end
