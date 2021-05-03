# frozen_string_literal: true

require_relative 'controller/error_handling'

module LinkedRails
  module Auth
    module Controller
      extend ActiveSupport::Concern

      included do
        include LinkedRails::Auth::AuthHelper
        include LinkedRails::Auth::Controller::ErrorHandling
      end
    end
  end
end
