# frozen_string_literal: true

module LinkedRails
  module Auth
    class Confirmation < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Updatable
      attr_accessor :current_user, :email, :token, :user, :password_token

      def anonymous_iri?
        token.blank?
      end

      def confirm!
        user&.confirm
      end

      def confirmed?
        user&.confirmed?
      end

      def description
        I18n.t('actions.confirmations.update.description', default: nil)
      end

      def entry_point
        @entry_point ||= LinkedRails::EntryPoint.new(
          parent: self,
          url: iri
        )
      end

      def form; end

      def http_method
        :PUT
      end

      def image; end

      def iri_opts
        {confirmation_token: token}
      end

      def redirect_url
        LinkedRails.iri
      end

      def submit_label
        I18n.t('actions.confirmations.update.submit', default: 'Confirm')
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
