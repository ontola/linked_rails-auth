# frozen_string_literal: true

module LinkedRails
  module Auth
    class ClientsController < Doorkeeper::ApplicationsController
      skip_before_action :authenticate_admin!, only: %i[create]

      def create
        @application = Doorkeeper::Application.new(application_params)

        if @application.save
          render json: new_client_response
        else
          errors = @application.errors.full_messages

          render json: {errors: errors}, status: :unprocessable_entity
        end
      end

      private

      def application_owner
        current_user unless current_user.guest?
      end

      def application_params
        permitted_params = params.permit(:client_name, :issuer, :redirect_uris, redirect_uris: [])
        {
          name: permitted_params[:client_name] || client_name_from_redirect_uri(permitted_params[:redirect_uris]),
          owner: application_owner,
          redirect_uri: permitted_params[:redirect_uris],
          scopes: permitted_scopes
        }
      end

      def available_scopes
        Doorkeeper.config.scopes.to_a
      end

      def client_name_from_redirect_uri(redirect_uris)
        redirect_uris&.map { |redirect_uri| URI(redirect_uri).host }&.uniq&.join(', ')
      end

      def new_client_response
        {
          client_id: @application.uid,
          client_secret: @application.secret,
          client_id_issued_at: @application.created_at.to_i,
          client_secret_expires_at: 0,
          redirect_uris: @application.redirect_uri.split
        }
      end

      def permitted_scopes
        requested_scopes & available_scopes
      end

      def requested_scopes
        scopes = params.permit(:scope, scope: [])[:scope]

        if scopes.is_a?(Array)
          Doorkeeper::OAuth::Scopes.from_array(scopes).to_a
        else
          Doorkeeper::OAuth::Scopes.from_string(scopes.to_s).to_a
        end
      end
    end
  end
end
