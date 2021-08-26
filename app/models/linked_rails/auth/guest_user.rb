# frozen_string_literal: true

module LinkedRails
  module Auth
    class GuestUser
      include ActiveModel::Model
      include LinkedRails::Model
      attr_writer :id

      def email; end

      def guest?
        true
      end

      def id
        @id ||= SecureRandom.hex
      end

      def iri_opts
        {id: id}
      end

      def self.iri
        Vocab.ontola[:GuestUser]
      end
    end
  end
end
