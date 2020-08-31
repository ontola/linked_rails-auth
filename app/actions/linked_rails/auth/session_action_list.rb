# frozen_string_literal: true

module LinkedRails
  module Auth
    class SessionActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.session_class
      end

      has_action(
        :create,
        create_options.merge(
          collection: false,
          include_object: true,
          object: nil,
          policy: :create?,
          root_relative_iri: -> { resource.root_relative_iri },
          type: [Vocab::ONTOLA['Create::Auth::Session'], RDF::Vocab::SCHEMA.CreateAction],
          url: -> { LinkedRails.iri(path: '/u/sessions') }
        )
      )
    end
  end
end
