require 'faraday'
require 'json'

module ChartMogul
  # Public: Primary class for interacting with the ChartMogul API.
  class Client
    include ImportApi

    API_ROOT_URL = "https://api.chartmogul.com"

    attr_reader :account_token
    attr_reader :secret_key

    # Public: Initialize a new ChartMogul::Client.
    #
    # options - A Hash of options used to initialize the client (default: {}):
    #           :account_token - The Account Token assigned to your account
    #                            (default: ENV["CHARTMOGUL_ACCOUNT_TOKEN"]).
    #           :secret_key    - The Secret key assigned to your account
    #                            (default: ENV["CHARTMOGUL_SECRET_KEY"]).
    def initialize(options={})
      @account_token = options.fetch(:account_token, ENV["CHARTMOGUL_ACCOUNT_TOKEN"])
      @secret_key    = options.fetch(:secret_key, ENV["CHARTMOGUL_SECRET_KEY"])
    end

    def connection
      @connection ||= Faraday.new(API_ROOT_URL) do |builder|
                        builder.basic_auth(account_token, secret_key)
                        builder.adapter Faraday.default_adapter
                      end
    end

    def ping?
      response = connection.get("/v1/ping")
      preprocess_response(response)['data'] == 'pong!'
    end

    def preprocess_response(response)
      puts response.body
      case response.status
      when 200..299
        JSON.parse(response.body, symbolize_names: true)
      when 401
        raise UnauthorizedError.new
      when 422
        result = JSON.parse(response.body, symbolize_names: true)
        raise ValidationError.new(result[:errors])
      else
        puts response.inspect
        raise StandardError.new("#{response.status} #{response.body}")
      end
    end

    class UnauthorizedError < StandardError
    end

    class ValidationError < StandardError

      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super("validation errors for #{errors.keys.join(', ')}")
      end

    end
  end
end