# frozen_string_literal: true

module LinkedRails
  module Auth
    class SessionActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.session_class
      end

      has_singular_create_action(
        root_relative_iri: lambda {
          uri = resource.root_relative_iri.dup
          uri.path ||= ''
          uri.path += '/new'
          uri.query = {redirect_url: resource.redirect_url}.compact.to_param.presence
          uri.to_s
        },
        type: [Vocab::ONTOLA['Create::Auth::Session'], RDF::Vocab::SCHEMA.CreateAction]
      )
    end
  end
end
