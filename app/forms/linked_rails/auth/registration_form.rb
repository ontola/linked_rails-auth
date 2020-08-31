# frozen_string_literal: true

module LinkedRails
  module Auth
    class RegistrationForm < LinkedRails.form_parent_class
      field :email,
            input_field: LinkedRails::Form::Field::EmailInput,
            min_count: 1
      field :password,
            input_field: LinkedRails::Form::Field::PasswordInput,
            min_count: 1
      field :password_confirmation,
            input_field: LinkedRails::Form::Field::PasswordInput,
            min_count: 1

      hidden do
        field :redirect_url
      end
    end
  end
end
