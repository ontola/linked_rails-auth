# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpBase < ApplicationRecord
      self.table_name = 'otp_secrets'
      self.abstract_class = true

      extend OtpHelper
      include OtpHelper

      has_one_time_password
      # rubocop:disable Rails/ReflectionClassName
      belongs_to :owner, class_name: LinkedRails.class_variable_get(:@@otp_owner_class)
      # rubocop:enable Rails/ReflectionClassName
      validates :owner, presence: true

      attr_accessor :encoded_session, :otp_attempt

      def singular_iri_opts
        {session: encoded_session}
      end

      private

      def decoded_session
        @decoded_session ||= session_from_param(encoded_session)
      end

      def validate_otp_attempt
        return if persisted? && authenticate_otp(otp_attempt, drift: LinkedRails::Auth.otp_drift)

        errors.add(:otp_attempt, I18n.t('actions.otp_secrets.errors.invalid'))
      end

      class << self
        def iri_template
          @iri_template ||= URITemplate.new("/#{route_key}{/id}{#fragment}")
        end

        def singular_iri_template
          @singular_iri_template ||= URITemplate.new("/#{singular_route_key}{?session}{#fragment}")
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
