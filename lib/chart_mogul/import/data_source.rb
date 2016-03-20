module ChartMogul
  module Import
    class DataSource

      attr_reader :created_at
      attr_reader :name
      attr_reader :status
      attr_reader :uuid

      def initialize(args)
        @name = args[:name]
        @status = args[:status]
        @uuid = args[:uuid]
        @created_at = Time.parse(args[:created_at]) if args[:created_at]
      end

    end
  end
end