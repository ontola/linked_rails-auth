# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretSerializer < LinkedRails.serializer_parent_class
      attribute :otp_attempt,
                predicate: LinkedRails.app_ns[:otp],
                datatype: RDF::XSD[:integer],
                if: method(:never)
      attribute :active, predicate: LinkedRails.app_ns[:otpActive]
      has_one :image, predicate: NS::SCHEMA.image
    end
  end
end
