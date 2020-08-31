# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationSerializer < LinkedRails.serializer_parent_class
      attribute :email, predicate: RDF::Vocab::SCHEMA.email, datatype: RDF::XSD[:string]
      attribute :redirect_url, predicate: Vocab::ONTOLA[:redirectUrl]
    end
  end
end
