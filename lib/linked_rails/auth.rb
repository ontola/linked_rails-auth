# frozen_string_literal: true

require 'active_model_otp'
require 'devise'
require 'doorkeeper'
require 'doorkeeper/jwt'
require 'rfc-822'

require 'linked_rails/auth/engine'
require 'linked_rails/auth/routes'
require 'linked_rails/auth/errors'
require 'linked_rails/auth/auth_helper'
require 'linked_rails/auth/controller'

module LinkedRails
  module Auth
    mattr_accessor :otp_drift, default: 60
  end
end

LinkedRails.configurable_class(nil, :user, default: 'User')
LinkedRails.configurable_class(nil, :guest_user, default: 'LinkedRails::Auth::GuestUser')
LinkedRails.configurable_class(nil, :access_token, default: 'LinkedRails::Auth::AccessToken')
LinkedRails.configurable_class(nil, :access_token_form, default: 'LinkedRails::Auth::AccessTokenForm')
LinkedRails.configurable_class(nil, :confirmation, default: 'LinkedRails::Auth::Confirmation')
LinkedRails.configurable_class(nil, :confirmation_form, default: 'LinkedRails::Auth::ConfirmationForm')
LinkedRails.configurable_class(nil, :password, default: 'LinkedRails::Auth::Password')
LinkedRails.configurable_class(nil, :password_form, default: 'LinkedRails::Auth::PasswordForm')
LinkedRails.configurable_class(nil, :registration, default: 'LinkedRails::Auth::Registration')
LinkedRails.configurable_class(nil, :registration_form, default: 'LinkedRails::Auth::RegistrationForm')
LinkedRails.configurable_class(nil, :session, default: 'LinkedRails::Auth::Session')
LinkedRails.configurable_class(nil, :session_form, default: 'LinkedRails::Auth::SessionForm')
LinkedRails.configurable_class(nil, :unlock, default: 'LinkedRails::Auth::Unlock')
LinkedRails.configurable_class(nil, :unlock_form, default: 'LinkedRails::Auth::UnlockForm')
LinkedRails.configurable_class(nil, :otp_attempt, default: 'LinkedRails::Auth::OtpAttempt')
LinkedRails.configurable_class(nil, :otp_attempt_form, default: 'LinkedRails::Auth::OtpAttemptForm')
LinkedRails.configurable_class(nil, :otp_owner, default: 'User')
LinkedRails.configurable_class(nil, :otp_secret, default: 'LinkedRails::Auth::OtpSecret')
LinkedRails.configurable_class(nil, :otp_secret_form, default: 'LinkedRails::Auth::OtpSecretForm')
