# frozen_string_literal: true

module LinkedRails
  module Auth
    module Controller
      module ErrorHandling
        extend ActiveSupport::Concern

        included do
          rescue_from LinkedRails::Auth::Errors::Unauthorized, with: :handle_error
          rescue_from LinkedRails::Auth::Errors::UnknownEmail, with: :handle_error
          rescue_from LinkedRails::Auth::Errors::Expired, with: :handle_error
        end
      end
    end
  end
end
