module ChartMogul
  module Import
    class Invoice

      attr_reader :uuid
      attr_reader :date
      attr_reader :external_id
      attr_reader :currency
      attr_reader :due_date
      attr_reader :line_items
      attr_reader :transactions

      class LineItem
        attr_reader :uuid
        attr_reader :external_id
        attr_reader :type
        attr_reader :subscription_uuid
        attr_reader :plan_uuid
        attr_reader :prorated
        attr_reader :service_period_start
        attr_reader :service_period_end
        attr_reader :amount_in_cents
        attr_reader :quantity
        attr_reader :discount_code
        attr_reader :discount_amount_in_cents
        attr_reader :tax_amount_in_cents

        def initialize(args)
          %i{uuid external_id type subscription_uuid plan_uuid prorated amount_in_cents quantity discount_code discount_amount_in_cents tax_amount_in_cents}
            .each do |key|
              instance_variable_set("@#{key}", args[key])
            end

          %i{service_period_start service_period_end}
            .each do |key|
              instance_variable_set("@#{key}", Time.parse(args[key])) if args[key]
            end
        end

      end


      class Transaction
        attr_reader :uuid
        attr_reader :external_id
        attr_reader :type
        attr_reader :date
        attr_reader :result

        def initialize(args)
          %i{uuid external_id type result}
            .each do |key|
              instance_variable_set("@#{key}", args[key])
            end

          instance_variable_set("@#{:date}", Time.parse(args[:date])) if args[:date]
        end

      end

      def initialize(args)
        @uuid = args[:uuid]
        @external_id = args[:external_id]
        @currency = args[:currency]
        @date = Time.parse(args[:date]) if args[:date]
        @due_date = Time.parse(args[:due_date]) if args[:due_date]

        @line_items = args[:line_items].map { |li| LineItem.new(li) }
        @transactions = args[:transactions].map { |li| Transaction.new(li) }
      end
    end
  end
end