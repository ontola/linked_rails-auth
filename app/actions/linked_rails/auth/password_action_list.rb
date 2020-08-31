# frozen_string_literal: true

module LinkedRails
  module Auth
    class PasswordActionList < LinkedRails.action_list_parent_class
      def self.actionable_class
        LinkedRails.password_class
      end

      has_action(
        :create,
        create_options.merge(
          collection: false,
          include_object: true,
          object: nil,
          policy: :create?,
          url: -> { LinkedRails.iri(path: '/users/password') },
          type: [Vocab::ONTOLA['Create::Auth::Password'], RDF::Vocab::SCHEMA.CreateAction]
        )
      )

      has_action(
        :update,
        update_options.merge(
          include_object: true,
          root_relative_iri: lambda {
            LinkedRails.iri(
              path: '/users/password/edit',
              query: {reset_password_token: resource.reset_password_token}.to_param
            )
          },
          url: -> { LinkedRails.iri(path: '/users/password') }
        )
      )
    end
  end
end
