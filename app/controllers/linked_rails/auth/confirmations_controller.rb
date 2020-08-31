# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationsController < Devise::ConfirmationsController
      include AuthHelper
      before_action :head_200, only: :show
      before_action :login_user, only: :show
      active_response :new, :show

      private

      def after_resending_confirmation_instructions_path_for(_resource_name)
        LinkedRails.iri(path: '/u/sign_in').path
      end

      def create_execute
        resource = resource_class.send_confirmation_instructions(resource_params)
        successfully_sent?(resource)
      end

      def create_success_location
        after_resending_confirmation_instructions_path_for(resource_name)
      end

      def create_success_message
        find_message(:send_instructions)
      end

      def head_200
        head 200 if request.head?
      end

      def login_user
        return if current_user == current_resource.user

        sign_in current_resource.user
        active_response_block do
          respond_with_resource(resource: current_resource.user)
        end
      end

      def new_resource
        LinkedRails.confirmation_class.new(user: current_user)
      end

      def original_token
        @original_token ||= params[:confirmation_token]
      end

      def resource_params
        params.fetch(resource_name, nil) ||
          params.fetch(controller_name.singularize, {})
      end

      def requested_resource
        LinkedRails.confirmation_class.new(
          current_user: current_user,
          email: user_by_token.email,
          user: user_by_token || raise(ActiveRecord::RecordNotFound),
          token: original_token
        )
      end

      def show_execute
        current_resource.confirm!
      end

      def show_failure
        respond_with_resource(
          resource: current_resource,
          notice: user_by_token.errors.full_messages.first
        )
      end

      def show_success
        respond_with_resource(
          resource: current_resource,
          notice: find_message(:confirmed)
        )
      end

      def user_by_token
        @user_by_token ||= LinkedRails.user_class.find_by(confirmation_token: original_token)
      end

      class << self
        def controller_class
          LinkedRails.confirmation_class
        end
      end
    end
  end
end
