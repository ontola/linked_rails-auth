# frozen_string_literal: true

module LinkedRails
  module Auth
    class Registration < LinkedRails.user_class
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Singularable

      class << self
        def action_list
          LinkedRails.registration_action_list_class
        end

        def form_class
          LinkedRails.registration_form_class
        end

        def iri_namespace
          Vocab::ONTOLA
        end

        def iri_template
          LinkedRails.user_class.iri_template
        end

        def requested_singular_resource(_params, user_context)
          build_new(user_context: user_context)
        end

        def singular_route_key
          'u/registration'
        end
      end
    end
  end
end
