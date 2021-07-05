# frozen_string_literal: true

module LinkedRails
  module Auth
    class UnlockSerializer < LinkedRails.serializer_parent_class
      attribute :email, predicate: Vocab.schema.email, datatype: RDF::XSD[:string]
    end
  end
end
