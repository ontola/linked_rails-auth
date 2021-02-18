# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptActionList < LinkedRails.action_list_parent_class
      has_action(
        :create,
        create_options.merge(
          collection: false,
          type: RDF::Vocab::SCHEMA[:CreateAction],
          include_object: true,
          url: -> { resource.iri },
          object: nil,
          parent: nil,
          policy: :create?,
          label: -> { I18n.t('actions.otp_secrets.create.label') }
        )
      )
    end
  end
end
