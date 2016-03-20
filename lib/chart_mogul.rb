require "chart_mogul/assertive"
require "chart_mogul/version"
require "chart_mogul/import_api"
require "chart_mogul/client"

module ChartMogul

  def self.client
    @client ||= Client.new
  end

end
