# frozen_string_literal: true

module LinkedRails
  module Auth
    class Registration < LinkedRails.user_class
      attr_accessor :redirect_url

      def singular_iri_opts
        {redirect_url: redirect_url}
      end

      class << self
        def form_class
          LinkedRails.registration_form_class
        end

        def iri_namespace
          Vocab.ontola
        end

        def requested_singular_resource(_params, user_context)
          build_new(user_context: user_context)
        end

        def singular_iri_template
          @singular_iri_template ||= URITemplate.new("/#{singular_route_key}{?redirect_url}")
        end

        def singular_route_key
          'u/registration'
        end
      end
    end
  end
end
