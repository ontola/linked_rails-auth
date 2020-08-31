# frozen_string_literal: true

module LinkedRails
  module Auth
    class Password < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Updatable, except: %i[Serializer]
      attr_accessor :email, :password, :password_confirmation, :user, :reset_password_token

      class << self
        def action_list
          LinkedRails.password_action_list_class
        end

        def iri_namespace
          Vocab::ONTOLA
        end

        def iri_template
          @iri_template ||= URITemplate.new('/users/password')
        end
      end
    end
  end
end
