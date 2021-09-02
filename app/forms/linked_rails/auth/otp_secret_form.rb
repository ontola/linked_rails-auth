# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretForm < LinkedRails.form_parent_class
      resource :provision_image,
               path: Vocab.schema.image
      field :otp_attempt, description: '', min_count: 1
    end
  end
end
