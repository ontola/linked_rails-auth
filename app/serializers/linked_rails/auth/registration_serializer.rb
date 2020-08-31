# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationSerializer < RDF::Serializers.serializer_for(LinkedRails.user_class)
      attribute :email, predicate: RDF::Vocab::SCHEMA.email, datatype: RDF::XSD[:string]
      attribute :password, predicate: Vocab::ONTOLA[:password], datatype: RDF::XSD[:string]
      attribute :password_confirmation, predicate: Vocab::ONTOLA[:passwordConfirmation], datatype: RDF::XSD[:string]
      attribute :redirect_url, predicate: Vocab::ONTOLA[:redirectUrl], datatype: RDF::XSD[:string]
    end
  end
end
