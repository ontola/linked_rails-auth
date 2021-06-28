# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationSerializer < RDF::Serializers.serializer_for(LinkedRails.user_class)
      attribute :email, predicate: Vocab.schema.email, datatype: RDF::XSD[:string]
      attribute :password, predicate: Vocab.ontola[:password], datatype: RDF::XSD[:string]
      attribute :password_confirmation, predicate: Vocab.ontola[:passwordConfirmation], datatype: RDF::XSD[:string]
      attribute :redirect_url, predicate: Vocab.ontola[:redirectUrl], datatype: RDF::XSD[:string]
    end
  end
end
