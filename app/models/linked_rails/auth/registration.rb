# frozen_string_literal: true

module LinkedRails
  module Auth
    class Registration < LinkedRails.user_class
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable

      class << self
        def action_list
          LinkedRails.registration_action_list_class
        end

        def iri_namespace
          Vocab::ONTOLA
        end

        def iri_template
          LinkedRails.user_class.iri_template
        end
      end
    end
  end
end
