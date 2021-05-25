# frozen_string_literal: true

module LinkedRails
  module Auth
    class UnlockActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.unlock_class
      end

      has_singular_create_action(
        form: -> { resource.class.try(:form_class) }
      )

      has_singular_update_action
    end
  end
end
