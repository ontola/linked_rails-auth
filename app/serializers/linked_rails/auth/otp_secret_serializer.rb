# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretSerializer < LinkedRails.serializer_parent_class
      secret_attribute :otp_attempt,
                       predicate: Vocab.app[:otp],
                       datatype: RDF::XSD[:integer]
      attribute :active, predicate: LinkedRails.app_ns[:otpActive]
      has_one :image, predicate: Vocab.schema.image
    end
  end
end
