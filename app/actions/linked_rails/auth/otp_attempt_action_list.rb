# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptActionList < LinkedRails.action_list_parent_class
      has_singular_create_action(
        type: RDF::Vocab::SCHEMA[:CreateAction],
        label: -> { I18n.t('actions.otp_secrets.create.label') }
      )
    end
  end
end
