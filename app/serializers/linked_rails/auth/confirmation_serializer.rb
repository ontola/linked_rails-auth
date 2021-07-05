# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationSerializer < LinkedRails.serializer_parent_class
      attribute :email, predicate: Vocab.schema.email, datatype: RDF::XSD[:string]
      attribute :redirect_url, predicate: Vocab.ontola[:redirectUrl]
    end
  end
end
