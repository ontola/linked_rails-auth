# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretSerializer < LinkedRails.serializer_parent_class
      attribute :otp_attempt,
                predicate: LinkedRails.app_vocab[:otp],
                datatype: RDF::XSD[:integer],
                if: method(:never)
      attribute :active, predicate: LinkedRails.app_vocab[:otpActive]
      has_one :image, predicate: Vocab.schema.image
    end
  end
end
