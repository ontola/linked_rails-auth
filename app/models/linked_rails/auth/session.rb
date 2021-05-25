# frozen_string_literal: true

module LinkedRails
  module Auth
    class Session < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Destroyable
      enhance LinkedRails::Enhancements::Singularable
      alias root_relative_iri root_relative_singular_iri

      attr_accessor :email, :redirect_url

      def singular_iri_opts
        {redirect_url: redirect_url}
      end

      class << self
        def action_list
          LinkedRails.session_action_list_class
        end

        def form_class
          LinkedRails.session_form_class
        end

        def iri_namespace
          Vocab::ONTOLA
        end

        def singular_iri_template
          @singular_iri_template ||= URITemplate.new("/#{singular_route_key}{?redirect_url}")
        end
        alias iri_template singular_iri_template

        def requested_singular_resource(params, _user_context)
          new(redirect_url: params[:redirect_url])
        end

        def singular_route_key
          'u/session'
        end
      end
    end
  end
end
