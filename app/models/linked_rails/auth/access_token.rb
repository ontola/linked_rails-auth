# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessToken < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable

      attr_accessor :email, :redirect_url, :password

      def iri_opts
        {redirect_url: redirect_url}
      end

      class << self
        def action_list
          LinkedRails.access_token_action_list_class
        end

        def iri_template
          @iri_template ||= URITemplate.new("/u/#{route_key}{?redirect_url}")
        end
      end
    end
  end
end
