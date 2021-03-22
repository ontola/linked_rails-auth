# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecret < ApplicationRecord
      self.table_name = 'otp_secrets'

      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Destroyable

      belongs_to :user
      has_one_time_password
      attr_accessor :otp_attempt, :session

      validate :validate_otp_attempt, on: %i[update]

      def image
        return if active?

        @image_object ||=
          LinkedRails::MediaObject.new(
            content_url: data_url,
            content_type: 'image/png',
            iri: LinkedRails.iri(path: iri.path, fragment: 'image')
          )
      end

      def iri_opts
        {id: id, session: session}
      end

      private

      def data_url
        [
          'data:image/svg+xml;base64,',
          RQRCode::QRCode.new(provisioning_uri(user.email, issuer: issuer)).as_svg(module_size: 4).to_s
        ].pack('A*m').delete("\n")
      end

      def issuer
        return issuer_name if Rails.env.production?

        "#{issuer_name} #{Rails.env}"
      end

      def issuer_name
        Rails.application.class.parent_name
      end

      def validate_otp_attempt
        return if persisted? && authenticate_otp(otp_attempt, drift: LinkedRails::Auth.otp_drift)

        errors.add(:otp_attempt, I18n.t('messages.otp_secrets.invalid'))
      end

      class << self
        def iri_template
          @iri_template ||= URITemplate.new('/u/otp_secrets{/id}{?session}{#fragment}')
        end

        def show_includes
          %i[image]
        end
      end
    end
  end
end
