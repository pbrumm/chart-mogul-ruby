module ChartMogul
  module Import
    class Plan

      attr_reader :uuid
      attr_reader :data_source_uuid
      attr_reader :name
      attr_reader :interval_count
      attr_reader :interval_unit

      attr_reader :external_id

      def initialize(args)
        args.each_pair do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end