# frozen_string_literal: true

require 'test_helper'

module LinkedRails
  module Auth
    class Test < ActiveSupport::TestCase
      test 'truth' do
        assert_kind_of Module, LinkedRails::Auth
      end
    end
  end
end
