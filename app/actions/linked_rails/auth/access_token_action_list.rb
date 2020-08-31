# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessTokenActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.access_token_class
      end

      has_action(
        :create,
        create_options.merge(
          collection: false,
          include_object: true,
          object: nil,
          policy: :create?,
          root_relative_iri: '/u/access_tokens/new',
          type: [Vocab::ONTOLA['Create::Auth::AccessToken'], RDF::Vocab::SCHEMA.CreateAction],
          url: -> { LinkedRails.iri(path: '/login') }
        )
      )
    end
  end
end
