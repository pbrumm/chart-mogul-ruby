module ChartMogul
  module Assertive
    def self.included(base)
      base.extend(Assertive)
    end

    private

    def assert!(predicate, message)
      return if predicate

      fail ArgumentError, message
    end

    def assert_fetch!(hash, key, message = nil)
      hash.fetch(key) do
        message = "#{key} must be defined" unless message
        fail ArgumentError, message
      end
    end

    def refute!(predicate, message)
      assert! !predicate, message
    end

    def refute_blank!(value, attribute_name)
      assert! (!value.nil? && value != ""), "#{attribute_name} cannot be nil or blank"
    end
  end
end
