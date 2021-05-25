# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessTokenActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.access_token_class
      end

      has_singular_create_action(
        type: [Vocab::ONTOLA['Create::Auth::AccessToken'], RDF::Vocab::SCHEMA.CreateAction],
        url: -> { LinkedRails.iri(path: '/login') }
      )
    end
  end
end
