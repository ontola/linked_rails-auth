# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptSerializer < LinkedRails.serializer_parent_class
      secret_attribute :otp_attempt,
                       predicate: Vocab.app[:otp],
                       datatype: RDF::XSD[:integer]
    end
  end
end
