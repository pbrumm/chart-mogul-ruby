require 'spec_helper'

module ChartMogul
  describe Client do
    let(:credentials) { { account_token: "a_token", secret_key: "a secret" } }
    let(:client) { Client.new(credentials) }

    describe "#ping?" do
      subject { client.ping? }

      context "successful" do
        before(:each) do
          stub_request(:get, request_stub_path(credentials, "/ping"))
            .to_return(status: 200, body: { data: "pong!"}.to_json)
        end
        it "should be true" do
          expect(subject).to be true
        end
      end
    end

  end
end