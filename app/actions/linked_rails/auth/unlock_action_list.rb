# frozen_string_literal: true

module LinkedRails
  module Auth
    class UnlockActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.unlock_class
      end

      has_action(
        :create,
        create_options.merge(
          collection: false,
          include_object: true,
          object: nil,
          policy: :create?,
          url: -> { LinkedRails.iri(path: '/users/unlock') }
        )
      )

      has_action(
        :update,
        update_options.merge(
          url: -> { LinkedRails.iri(path: '/users/unlock') }
        )
      )
    end
  end
end
