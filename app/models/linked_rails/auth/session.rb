# frozen_string_literal: true

module LinkedRails
  module Auth
    class Session < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable

      attr_accessor :email, :redirect_url

      def iri_opts
        {redirect_url: redirect_url}
      end

      class << self
        def action_list
          LinkedRails.session_action_list_class
        end

        def iri_namespace
          Vocab::ONTOLA
        end

        def iri_template
          @iri_template ||= URITemplate.new('/u/sign_in{?redirect_url}')
        end
      end
    end
  end
end
