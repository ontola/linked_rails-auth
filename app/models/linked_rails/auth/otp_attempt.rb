# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttempt < OtpBase
      def raise_on_persisting(_opts = {})
        raise "#{self.class.name} should not be persisted"
      end
      ActiveRecord::Persistence.instance_methods.each do |method|
        alias_method method, :raise_on_persisting unless method.to_s.include?('?')
      end
      alias root_relative_iri root_relative_singular_iri

      def save
        validate_otp_attempt

        errors.empty?
      end

      class << self
        def form_class
          LinkedRails.otp_attempt_form_class
        end

        def singular_route_key
          'u/otp_attempt'
        end

        def requested_singular_resource(params, user_context)
          owner = owner_for_otp(params, user_context)
          return if owner.blank?

          attempt = LinkedRails.otp_attempt_class.find_by(owner: owner) || LinkedRails.otp_attempt_class.new
          attempt.encoded_session = params[:session]
          attempt
        end
      end
    end
  end
end
