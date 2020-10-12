# frozen_string_literal: true

module LinkedRails
  module Auth
    class Confirmation < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      attr_accessor :current_user, :email, :token, :user, :password_token

      def anonymous_iri?
        token.blank?
      end

      def confirm!
        user&.confirm
      end

      def iri_opts
        {confirmation_token: token}
      end

      def redirect_url
        return if current_user != user

        LinkedRails.iri
      end

      private

      def reset_password?
        user.present? && user.encrypted_password.blank?
      end

      def set_reset_password_token
        self.password_token = user.send(:set_reset_password_token)
      end

      class << self
        def action_list
          LinkedRails.confirmation_action_list_class
        end

        def iri_namespace
          Vocab::ONTOLA
        end

        def iri_template
          @iri_template ||= URITemplate.new('/users/confirmation{?confirmation_token}')
        end
      end
    end
  end
end
