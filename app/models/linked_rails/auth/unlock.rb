# frozen_string_literal: true

module LinkedRails
  module Auth
    class Unlock < LinkedRails::Resource
      attr_accessor :email, :unlock_token, :user
      alias root_relative_iri root_relative_singular_iri

      def anonymous_iri?
        unlock_token.blank?
      end

      def singular_iri_opts
        {unlock_token: unlock_token}
      end

      class << self
        def decrypt_token(token)
          Devise.token_generator.digest(self, :unlock_token, token)
        end

        def form_class
          LinkedRails.unlock_form_class
        end

        def iri_namespace
          Vocab.ontola
        end

        def singular_iri_template
          @singular_iri_template ||= URITemplate.new("/#{singular_route_key}{?unlock_token}")
        end

        def singular_route_key
          'u/unlock'
        end

        def requested_singular_resource(params, _user_context)
          token = decrypt_token(token)
          user_by_token ||= LinkedRails.user_class.find_by(unlock_token: token)
          return new(unlock_token: params[:unlock_token]) if user_by_token.blank?

          new(
            unlock_token: params[:unlock_token],
            user: user_by_token
          )
        end
      end
    end
  end
end
