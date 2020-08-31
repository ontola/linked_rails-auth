# frozen_string_literal: true

module LinkedRails
  module Auth
    class PasswordSerializer < LinkedRails.serializer_parent_class
      attribute :email, predicate: RDF::Vocab::SCHEMA.email, datatype: RDF::XSD[:string]
      attribute :password,
                predicate: Vocab::ONTOLA[:password],
                datatype: Vocab::ONTOLA['datatype/password'],
                if: method(:never)
      attribute :password_confirmation,
                predicate: Vocab::ONTOLA[:passwordConfirmation],
                datatype: Vocab::ONTOLA['datatype/password'],
                if: method(:never)
      attribute :reset_password_token, predicate: Vocab::ONTOLA[:resetPasswordToken], datatype: RDF::XSD[:string]
    end
  end
end
