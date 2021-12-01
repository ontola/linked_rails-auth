# frozen_string_literal: true

module LinkedRails
  module Auth
    class Confirmation < LinkedRails::Resource
      attr_accessor :confirmation_token, :email, :user, :password_token
      alias root_relative_iri root_relative_singular_iri

      validates :email,
                allow_blank: false,
                format: {with: RFC822::EMAIL}

      def anonymous_iri?
        confirmation_token.blank?
      end

      def confirm!
        user!.confirm
      end

      delegate :confirmed?, to: :user!

      def singular_iri_opts
        {confirmation_token: confirmation_token}
      end

      def redirect_url
        LinkedRails.iri
      end

      def user!
        user || raise(ActiveRecord::RecordNotFound)
      end

      class << self
        def form_class
          LinkedRails.confirmation_form_class
        end

        def iri_namespace
          Vocab.ontola
        end

        def requested_singular_resource(params, _user_context)
          return new unless params.key?(:confirmation_token)

          user_by_token = LinkedRails.user_class.find_by(confirmation_token: params[:confirmation_token])
          return if user_by_token.blank?

          new(
            confirmation_token: params[:confirmation_token],
            user: user_by_token
          )
        end

        def singular_iri_template
          @singular_iri_template ||= URITemplate.new("/#{singular_route_key}{?confirmation_token}")
        end

        def singular_route_key
          'u/confirmation'
        end
      end
    end
  end
end
