# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptSerializer < LinkedRails.serializer_parent_class
      attribute :otp_attempt,
                predicate: LinkedRails.app_vocab[:otp],
                datatype: RDF::XSD[:integer],
                if: method(:never)
    end
  end
end
