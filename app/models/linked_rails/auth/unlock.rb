# frozen_string_literal: true

module LinkedRails
  module Auth
    class Unlock < LinkedRails::Resource
      enhance LinkedRails::Enhancements::Actionable
      enhance LinkedRails::Enhancements::Creatable
      enhance LinkedRails::Enhancements::Updatable, except: %i[Serializer]
      attr_accessor :email

      class << self
        def action_list
          LinkedRails.unlock_action_list_class
        end

        def iri_namespace
          Vocab::ONTOLA
        end

        def iri_template
          @iri_template ||= URITemplate.new('/users/unlock')
        end
      end
    end
  end
end
