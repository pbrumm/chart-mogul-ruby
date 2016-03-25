$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'chart_mogul'
require 'webmock/rspec'

def request_stub_path(credentials, path)
  "https://#{credentials[:account_token]}:#{credentials[:secret_key]}@api.chartmogul.com/v1#{path}"
end