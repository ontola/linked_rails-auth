# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretForm < LinkedRails.form_parent_class
      resource :provision_image,
               description: -> { I18n.t('otp_secrets.properties.provision_image.description') },
               path: NS::SCHEMA.image
      field :otp_attempt, description: '', min_count: 1
    end
  end
end
