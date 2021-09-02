# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationsController < Devise::ConfirmationsController
      controller_class LinkedRails.confirmation_class
      active_response :show, :update

      private

      def after_confirmation_path_for(_resource_name, _resource)
        if current_user.guest?
          LinkedRails.iri(path: '/u/session/new').path
        else
          LinkedRails.iri.path
        end
      end

      def after_resending_confirmation_instructions_path_for(_resource_name)
        LinkedRails.iri(path: '/u/session/new').path
      end

      def already_confirmed_notice
        I18n.t('errors.messages.already_confirmed')
      end

      def create_failure_message
        current_resource!.errors.full_messages.join("\n")
      end

      def create_execute
        @current_resource = resource_class.send_confirmation_instructions(resource_params)

        successfully_sent?(current_resource!)
      end

      def create_success_location
        after_resending_confirmation_instructions_path_for(resource_name)
      end

      def create_success_message
        find_message(:send_instructions)
      end

      def original_token
        @original_token ||= params[:confirmation_token]
      end

      def resource_params
        params.fetch(resource_name, nil) ||
          params.fetch(controller_name.singularize, {})
      end

      def show_success
        return super unless current_resource!.confirmed?

        add_exec_action_header(response.headers, ontola_redirect_action(current_resource!.redirect_url))
        add_exec_action_header(response.headers, ontola_snackbar_action(already_confirmed_notice))

        super
      end

      def update_execute
        current_resource!.confirm!
      end

      def update_failure
        respond_with_redirect(
          location: after_confirmation_path_for(resource_name, current_resource!),
          notice: user_by_token.errors.full_messages.first
        )
      end

      def update_success
        respond_with_redirect(
          location: after_confirmation_path_for(resource_name, current_resource!),
          notice: find_message(:confirmed)
        )
      end
    end
  end
end
