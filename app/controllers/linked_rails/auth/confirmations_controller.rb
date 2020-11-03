# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationsController < Devise::ConfirmationsController
      include AuthHelper
      active_response :new, :show, :update

      private

      def after_confirmation_path_for(_resource_name, _resource)
        if current_user.guest?
          LinkedRails.iri(path: '/u/sign_in').path
        else
          LinkedRails.iri.path
        end
      end

      def after_resending_confirmation_instructions_path_for(_resource_name)
        LinkedRails.iri(path: '/u/sign_in').path
      end

      def already_confirmed_notice
        I18n.t('errors.messages.already_confirmed')
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
        @requested_resource ||=
          LinkedRails.confirmation_class.new(
            current_user: current_user,
            email: user_by_token&.email,
            user: user_by_token || raise(ActiveRecord::RecordNotFound),
            token: original_token
          )
      end

      def show_includes
        %i[entry_point]
      end

      def show_success
        return super unless current_resource.confirmed?

        add_exec_action_header(response.headers, ontola_redirect_action(redirect_location))
        add_exec_action_header(response.headers, ontola_snackbar_action(already_confirmed_notice))

        super
      end

      def update_execute
        current_resource.confirm!
      end

      def update_failure
        respond_with_redirect(
          location: after_confirmation_path_for(resource_name, current_resource),
          notice: user_by_token.errors.full_messages.first
        )
      end

      def update_success
        respond_with_redirect(
          location: after_confirmation_path_for(resource_name, current_resource),
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
