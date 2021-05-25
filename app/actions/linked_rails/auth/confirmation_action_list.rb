# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.confirmation_class
      end

      has_singular_create_action(
        form: -> { resource.class.try(:form_class) },
        type: [Vocab::ONTOLA['Create::Auth::Confirmation'], RDF::Vocab::SCHEMA.CreateAction]
      )
      has_singular_update_action(
        form: -> { nil },
        label: I18n.t('actions.confirmations.update.label', default: nil)
      )
    end
  end
end
