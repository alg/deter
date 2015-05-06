require 'active_support/concern'

module Concerns
  module WithExtendedAttributes
    extend ActiveSupport::Concern

    included do
      def xa
        ExtendedAttributes.new(self)
      end
    end

    class ExtendedAttributes
      def initialize(obj)
        @obj = obj
      end

      # returns the value of the named key
      def [](name)
        if (key = gen_key(name)).present?
          Rails.cache.read(key)
        else
          nil
        end
      end

      # sets the value of the named key
      def []=(name, value)
        if (key = gen_key(name)).present?
          Rails.cache.write(key, value)
        end
      end

      private

      # generates the key if the object has xa_key
      def gen_key(name)
        if (xa_key = @obj.xa_key).present?
          "xa:#{xa_key}:#{name}"
        else
          nil
        end
      end
    end
  end
end
