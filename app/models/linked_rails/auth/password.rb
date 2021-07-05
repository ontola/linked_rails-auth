# frozen_string_literal: true

module LinkedRails
  module Auth
    class Password < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Updatable
      enhance LinkedRails::Enhancements::Singularable
      attr_accessor :email, :password, :password_confirmation, :user, :reset_password_token
      alias root_relative_iri root_relative_singular_iri

      class << self
        def action_list
          LinkedRails.password_action_list_class
        end

        def decrypt_token(token)
          Devise.token_generator.digest(self, :reset_password_token, token)
        end

        def form_class
          LinkedRails.password_form_class
        end

        def iri_namespace
          Vocab.ontola
        end

        def requested_singular_resource(params, _user_context)
          reset_password_token = decrypt_token(params[:reset_password_token])
          user_by_token ||= LinkedRails.user_class.find_by(reset_password_token: reset_password_token)
          return new(reset_password_token: params[:reset_password_token]) if user_by_token.blank?

          new(
            reset_password_token: params[:reset_password_token],
            user: user_by_token
          )
        end

        def singular_route_key
          'u/password'
        end
      end
    end
  end
end
