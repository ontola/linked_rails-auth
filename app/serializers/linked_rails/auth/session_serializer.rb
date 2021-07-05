# frozen_string_literal: true

module LinkedRails
  module Auth
    class SessionSerializer < LinkedRails.serializer_parent_class
      attribute :email, predicate: Vocab.schema.email, datatype: RDF::XSD[:string]
      attribute :redirect_url, predicate: Vocab.ontola[:redirectUrl], datatype: RDF::XSD[:string]
    end
  end
end
