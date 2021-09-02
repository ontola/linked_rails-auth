# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessToken < LinkedRails::Resource
      attr_accessor :email, :redirect_url, :password
      alias root_relative_iri root_relative_singular_iri

      def singular_iri_opts
        {redirect_url: redirect_url}
      end

      class << self
        def form_class
          LinkedRails.access_token_form_class
        end

        def singular_iri_template
          @singular_iri_template ||= URITemplate.new("/#{singular_route_key}{?redirect_url}")
        end

        def singular_route_key
          'u/access_token'
        end

        def requested_singular_resource(params, _user_context)
          new(redirect_url: params[:redirect_url])
        end
      end
    end
  end
end
