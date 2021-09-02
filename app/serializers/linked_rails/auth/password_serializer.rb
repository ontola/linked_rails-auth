# frozen_string_literal: true

module LinkedRails
  module Auth
    class PasswordSerializer < LinkedRails.serializer_parent_class
      attribute :email, predicate: Vocab.schema.email, datatype: RDF::XSD[:string]
      secret_attribute :password,
                       predicate: Vocab.ontola[:password],
                       datatype: Vocab.ontola['datatype/password']
      secret_attribute :password_confirmation,
                       predicate: Vocab.ontola[:passwordConfirmation],
                       datatype: Vocab.ontola['datatype/password']
      attribute :reset_password_token, predicate: Vocab.ontola[:resetPasswordToken], datatype: RDF::XSD[:string]
    end
  end
end
