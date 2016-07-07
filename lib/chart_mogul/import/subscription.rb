module ChartMogul
  module Import
    class Subscription

      attr_reader :uuid
      attr_reader :plan_uuid
      attr_reader :external_id
      attr_reader :data_source_uuid
      def initialize(args)
          %i{uuid external_id plan_uuid data_source_uuid}
            .each do |key|
              instance_variable_set("@#{key}", args[key])
            end

      end
    end
  end
end
