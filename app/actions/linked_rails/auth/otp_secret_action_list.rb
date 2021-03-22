# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretActionList < LinkedRails.action_list_parent_class
      has_action(
        :create,
        create_options.merge(
          collection: false,
          type: RDF::Vocab::SCHEMA[:CreateAction],
          include_object: true,
          url: lambda {
            LinkedRails.iri(
              path: 'u/otp_secrets',
              query: {session: resource.session}.compact.to_param.presence
            )
          },
          object: nil,
          parent: nil,
          policy: :create?,
          root_relative_iri: lambda {
            RDF::URI(
              path: '/u/otp_secrets/new',
              query: {session: resource.session}.compact.to_param.presence
            )
          },
          label: -> { I18n.t('actions.otp_secrets.create.label') }
        )
      )
      has_action(
        :destroy,
        destroy_options.merge(
          description: -> { I18n.t('actions.otp_secrets.destroy.description', name: resource.user.display_name) }
        )
      )
    end
  end
end
