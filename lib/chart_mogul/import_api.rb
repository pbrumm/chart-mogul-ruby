require_relative 'import/customer'
require_relative 'import/data_source'
require_relative 'import/plan'

module ChartMogul
  module ImportApi
    include Assertive

    def list_data_sources
      response = connection.get("/v1/import/data_sources")
      preprocess_response(response)[:data_sources]
        .map { |ds| Import::DataSource.new(ds) }
    end

    def create_data_source(args)
      refute_blank! args[:name], :name

      response = connection.post do |request|
        request.url "/v1/import/data_sources"
        request.headers['Content-Type'] = "application/json"
        request.body = args.to_json
      end

      Import::DataSource.new(preprocess_response(response))
    end

    def list_customers
      response = connection.get("/v1/import/customers")
      preprocess_response(response)[:customers]
        .map { |c| Import::Customer.new(c) }
    end

    def create_customer(args)
      [:data_source_uuid, :external_id, :name].each do |attribute|
        refute_blank! args[attribute], attribute
      end

      response = connection.post do |request|
        request.url "/v1/import/customers"
        request.headers['Content-Type'] = "application/json"
        request.body = args.to_json
      end

      Import::Customer.new(preprocess_response(response))
    end

    def list_plans
      response = connection.get("/v1/import/plans")
      preprocess_response(response)[:plans]
        .map { |c| Import::Plan.new(c) }
    end

    def create_plan(args)
      [:data_source_uuid, :name, :interval_unit].each do |attribute|
        refute_blank! args[attribute], attribute
      end

      assert! (args[:interval_count].is_a?(Integer) && args[:interval_count] > 0), "interval_count must be an integer greater than zero"

      response = connection.post do |request|
        request.url "/v1/import/plans"
        request.headers['Content-Type'] = "application/json"
        request.body = args.to_json
      end

      Import::Plan.new(preprocess_response(response))
    end
  end
end