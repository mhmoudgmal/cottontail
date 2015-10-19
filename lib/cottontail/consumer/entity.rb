module Cottontail #:nodoc:
  module Consumer #:nodoc:
    class Entity #:nodoc:
      include Comparable

      VALID_KEYS = [:exchange, :queue, :route]

      def initialize(options = {}, &block)
        @options = options.keep_if { |k, _| VALID_KEYS.include?(k) }
        @block = block
      end

      def matches?(key, value)
        [value, nil, :any].include?(@options[key])
      end

      def exec(object, *args)
        object.instance_exec(*args, &@block)
      end

      protected

      def <=>(other)
        comparables <=> other.comparables
      end

      def comparables
        VALID_KEYS.map { |key| Property.new(@options[key] || '') }
      end

      class Property < String #:nodoc:
        protected

        def <=>(other)
          case
          when length == 0 && other.length == 0 then 0
          when length == 0 then 1
          when other.length == 0 then -1
          else super
          end
        end
      end
    end
  end
end
