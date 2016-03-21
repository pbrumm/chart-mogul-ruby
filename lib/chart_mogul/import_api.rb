require_relative 'import/customer'
require_relative 'import/data_source'
require_relative 'import/plan'

module ChartMogul
  module ImportApi
    include Assertive

    # Public - list DataSources
    #
    # Returns an Array of ChartMogul::Import::DataSource
    def list_data_sources
      response = connection.get("/v1/import/data_sources")
      preprocess_response(response)[:data_sources]
        .map { |ds| Import::DataSource.new(ds) }
    end

    # Public - create a DataSource
    #
    # args   - Hash of params only :name is supported
    #          {
    #            name: "Name of data source"
    #          }
    #
    # Returns a ChartMogul::Import::DataSource
    def create_data_source(args)
      refute_blank! args[:name], :name

      response = connection.post do |request|
        request.url "/v1/import/data_sources"
        request.headers['Content-Type'] = "application/json"
        request.body = args.to_json
      end

      Import::DataSource.new(preprocess_response(response))
    end

    # Public - list all Customers.
    #          this will page through all customers see #list_customers_each
    #          for iterator method to prevent loading the whole array in
    #          memory
    #
    # options - see #list_customers_each
    #
    # Returns an Array of ChartMogul::Import::Customer
    def list_customers(options={})
      customers = []
      list_customers_each { |c| customers << c }
      customers
    end

    # Public    - iterate through all customers
    #
    # options   - Hash of filter options
    #             :data_source_uuid
    #
    # Returns and Enumerable that will yield a ChartMogul::Import::Customer for
    # each record
    def list_customers_each(options={}, &block)
      params = { page_number: 1 }
      params[:data_source_uuid] = options[:data_source_uuid] if options[:data_source_uuid]

      begin
        result = preprocess_response(connection.get("/v1/import/customers", params))
        result[:customers].each do |customer|
          yield Import::Customer.new(customer)
        end
        params[:page_number] = result[:current_page]
      end while params[:page_number] < result[:total_pages]
    end

    def create_customer(args)
      [:data_source_uuid, :external_id, :name].each do |attribute|
        refute_blank! args[attribute], attribute
      end

      # ChartMogul API will 500 if nill keys are sent
      args.keys.each do |key|
        refute! args[key].nil?
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