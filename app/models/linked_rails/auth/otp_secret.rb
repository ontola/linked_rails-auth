# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecret < OtpBase
      enhance LinkedRails::Enhancements::Destroyable

      validate :validate_otp_attempt, on: %i[update]

      def image
        return if active? || !persisted?

        @image ||=
          LinkedRails::MediaObject.new(
            content_url: data_url,
            content_type: 'image/png',
            iri: LinkedRails.iri(path: root_relative_iri, fragment: 'image')
          )
      end

      def iri_opts
        {id: id}
      end

      def redirect_url
        decoded_session['redirect_uri'] || LinkedRails.iri.to_s
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

      class << self
        def form_class
          LinkedRails.otp_secret_form_class
        end

        def preview_includes
          %i[image]
        end

        def requested_singular_resource(params, user_context)
          user = user_for_otp(params, user_context)
          return if user.blank?

          secret = LinkedRails.otp_secret_class.find_or_create_by!(user: user)
          secret.encoded_session = params[:session]
          secret
        rescue ActiveRecord::RecordNotUnique
          requested_singular_resource(params, user_context)
        end

        def requested_single_resource(params, _user_context)
          LinkedRails.otp_secret_class.find_by(id: params[:id])
        end

        def route_key
          'u/otp_secrets'
        end

        def singular_route_key
          'u/otp_secret'
        end
      end
    end
  end
end
