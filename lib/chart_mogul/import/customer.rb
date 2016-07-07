module ChartMogul
  module Import
    class Customer

      attr_reader :id
      attr_reader :uuid
      attr_reader :data_source_uuid
      attr_reader :external_id

      attr_reader :name
      attr_reader :company
      attr_reader :email
      attr_reader :city
      attr_reader :state
      attr_reader :country
      attr_reader :zip

      def initialize(args)
        args.each_pair do |key, value|
          if self.respond_to?(key)
            instance_variable_set("@#{key}", value)
          end
        end
      end

    end
  end
end
