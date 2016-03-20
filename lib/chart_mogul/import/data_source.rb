module ChartMogul
  module Import
    class DataSource
      include Assertive

      attr_reader :created_at
      attr_reader :name
      attr_reader :status
      attr_reader :uuid

      def initialize(args={})
        @name = assert_fetch!(args, :name)
        @status = args[:status]
        @uuid = args[:uuid]
        @created_at = Time.parse(args[:created_at]) if args[:created_at]
      end

      def save
        ChartMogul.client
          .post("/v1/import/data_sources", { name: name })
      end

      def self.all
        ChartMogul.client
          .get("/v1/import/data_sources")
          .map { |ds| DataSource.new(ds) }
      end
    end
  end
end