# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessTokenForm < LinkedRails.form_parent_class
      field :email,
            input_field: LinkedRails::Form::Field::EmailInput,
            min_count: 1
      field :password,
            description: '',
            input_field: LinkedRails::Form::Field::PasswordInput,
            min_count: 1
      resource :reset_password, url: -> { LinkedRails.iri(path: '/u/password/new') }

      hidden do
        field :redirect_url
      end
    end
  end
end
