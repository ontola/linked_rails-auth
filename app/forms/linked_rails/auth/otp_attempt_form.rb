# frozen_string_literal: true

module LinkedRails
  module Auth
    class OtpAttemptForm < LinkedRails.form_parent_class
      field :otp_attempt, description: '', min_count: 1
    end
  end
end
