# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttempt < LinkedRails.otp_secret_class
      def raise_on_persisting(_opts = {})
        raise "#{self.class.name} should not be persisted"
      end
      ActiveRecord::Persistence.instance_methods.each do |method|
        alias_method method, :raise_on_persisting unless method.to_s.include?('?')
      end

      def iri_opts
        {session: session}
      end

      def save
        validate_otp_attempt

        errors.empty?
      end

      private

      def anonymous_iri?
        false
      end

      class << self
        def iri_template
          @iri_template ||= URITemplate.new('/u/otp_attempts{/id}{?session}{#fragment}')
        end
      end
    end
  end
end
