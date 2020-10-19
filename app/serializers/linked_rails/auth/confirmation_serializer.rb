# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationSerializer < LinkedRails.serializer_parent_class
      has_one :entry_point, predicate: RDF::Vocab::SCHEMA.target
      attribute :email, predicate: RDF::Vocab::SCHEMA.email, datatype: RDF::XSD[:string]
      attribute :redirect_url, predicate: Vocab::ONTOLA[:redirectUrl]
    end
  end
end
