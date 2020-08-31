# frozen_string_literal: true

module LinkedRails
  module Auth
    class ConfirmationForm < LinkedRails.form_parent_class
      field :email, input_field: LinkedRails::Form::Field::EmailInput, min_count: 1
    end
  end
end
