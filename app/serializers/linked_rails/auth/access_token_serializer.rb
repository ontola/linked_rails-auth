# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessTokenSerializer < LinkedRails.serializer_parent_class
      attribute :email, predicate: RDF::Vocab::SCHEMA.email, datatype: RDF::XSD[:string]
      attribute :password, predicate: Vocab::ONTOLA[:password], datatype: RDF::XSD[:string]
      attribute :redirect_url, predicate: Vocab::ONTOLA[:redirectUrl], datatype: RDF::XSD[:string]
    end
  end
end
