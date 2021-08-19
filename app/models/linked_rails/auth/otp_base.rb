# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpBase < ApplicationRecord
      self.table_name = 'otp_secrets'
      self.abstract_class = true

      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Singularable

      extend OtpHelper
      include OtpHelper

      has_one_time_password
      belongs_to :owner, class_name: LinkedRails.otp_owner_class.to_s
      validates :owner, presence: true

      attr_accessor :encoded_session, :otp_attempt

      private

      def decoded_session
        @decoded_session ||= session_from_param(encoded_session)
      end

      def singular_iri_opts
        {session: encoded_session}
      end

      def validate_otp_attempt
        return if persisted? && authenticate_otp(otp_attempt, drift: LinkedRails::Auth.otp_drift)

        errors.add(:otp_attempt, I18n.t('messages.otp_secrets.invalid'))
      end

      class << self
        def iri_template
          @iri_template ||= URITemplate.new("/#{route_key}{/id}{?session}{#fragment}")
        end

        def singular_iri_template
          @singular_iri_template ||= URITemplate.new("{/parent_iri*}/#{singular_route_key}{?session}{#fragment}")
        end

        def owner_for_otp(params, user_context)
          if params.key?(:session)
            owner_from_session(params[:session])
          else
            user_context unless user_context.guest?
          end
        end
      end
    end
  end
end
