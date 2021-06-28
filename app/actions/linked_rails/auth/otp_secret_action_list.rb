# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpSecretActionList < LinkedRails.action_list_parent_class
      has_singular_create_action(
        type: Vocab.schema[:CreateAction],
        url: lambda {
          LinkedRails.iri(
            path: 'u/otp_secret',
            query: {session: resource.encoded_session}.compact.to_param.presence
          )
        },
        root_relative_iri: lambda {
          RDF::URI(
            path: '/u/otp_secret/new',
            query: {session: resource.encoded_session}.compact.to_param.presence
          )
        },
        label: -> { I18n.t('actions.otp_secrets.create.label') }
      )

      has_singular_destroy_action(
        description: -> { I18n.t('actions.otp_secrets.destroy.description', name: resource.user.display_name) }
      )
    end
  end
end
