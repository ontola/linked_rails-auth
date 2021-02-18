# frozen_string_literal: true

require 'linked_rails/auth/engine'
require 'linked_rails/auth/routes'
require 'linked_rails/auth/auth_helper'

module LinkedRails
  module Auth; end
end

LinkedRails.configurable_class(nil, :user, default: 'User')
LinkedRails.configurable_class(nil, :guest_user, default: 'GuestUser')
LinkedRails.configurable_class(nil, :access_token, default: 'LinkedRails::Auth::AccessToken')
LinkedRails.configurable_class(nil, :access_token_action_list, default: 'LinkedRails::Auth::AccessTokenActionList')
LinkedRails.configurable_class(nil, :access_token_form, default: 'LinkedRails::Auth::AccessTokenForm')
LinkedRails.configurable_class(nil, :confirmation, default: 'LinkedRails::Auth::Confirmation')
LinkedRails.configurable_class(nil, :confirmation_action_list, default: 'LinkedRails::Auth::ConfirmationActionList')
LinkedRails.configurable_class(nil, :confirmation_form, default: 'LinkedRails::Auth::ConfirmationForm')
LinkedRails.configurable_class(nil, :password, default: 'LinkedRails::Auth::Password')
LinkedRails.configurable_class(nil, :password_action_list, default: 'LinkedRails::Auth::PasswordActionList')
LinkedRails.configurable_class(nil, :password_form, default: 'LinkedRails::Auth::PasswordForm')
LinkedRails.configurable_class(nil, :registration, default: 'LinkedRails::Auth::Registration')
LinkedRails.configurable_class(nil, :registration_action_list, default: 'LinkedRails::Auth::RegistrationActionList')
LinkedRails.configurable_class(nil, :registration_form, default: 'LinkedRails::Auth::RegistrationForm')
LinkedRails.configurable_class(nil, :session, default: 'LinkedRails::Auth::Session')
LinkedRails.configurable_class(nil, :session_action_list, default: 'LinkedRails::Auth::SessionActionList')
LinkedRails.configurable_class(nil, :session_form, default: 'LinkedRails::Auth::SessionForm')
LinkedRails.configurable_class(nil, :unlock, default: 'LinkedRails::Auth::Unlock')
LinkedRails.configurable_class(nil, :unlock_action_list, default: 'LinkedRails::Auth::UnlockActionList')
LinkedRails.configurable_class(nil, :unlock_form, default: 'LinkedRails::Auth::UnlockForm')
LinkedRails.configurable_class(nil, :otp_attempt, default: 'LinkedRails::Auth::OtpAttempt')
LinkedRails.configurable_class(nil, :otp_attempt_action_list, default: 'LinkedRails::Auth::OtpAttemptActionList')
LinkedRails.configurable_class(nil, :otp_attempt_form, default: 'LinkedRails::Auth::OtpAttemptForm')
LinkedRails.configurable_class(nil, :otp_secret, default: 'LinkedRails::Auth::OtpSecret')
LinkedRails.configurable_class(nil, :otp_secret_action_list, default: 'LinkedRails::Auth::OtpSecretActionList')
LinkedRails.configurable_class(nil, :otp_secret_form, default: 'LinkedRails::Auth::OtpSecretForm')
