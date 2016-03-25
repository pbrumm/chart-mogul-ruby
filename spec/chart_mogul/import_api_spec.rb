require 'spec_helper'

module ChartMogul
  describe ImportApi do
    let(:credentials) { { account_token: "a_token", secret_key: "a secret" } }
    let(:client) { Client.new(credentials) }

    describe "list_data_sources" do

      let(:data_sources) {[
                            {
                              uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                              name: "In-house billing",
                              created_at: "2016-01-10 15:34:05",
                              status: "never_imported"
                            },
                            {
                              uuid: "ds_ade45e52-47a4-231a-1ed2-eb6b9e541213",
                              name: "ChargeBee connection",
                              created_at: "2016-01-09 10:14:15",
                              status: "import_complete"
                            }
                          ]}
      before(:each) do
        stub_request(:get, request_stub_path(credentials, "/import/data_sources"))
          .to_return(status: 200, body: { data_sources: data_sources }.to_json)
      end

      subject { client.list_data_sources }

      it "should return all of the data sources" do
        result = subject
        data_sources.each_with_index do |data_source, i|
          expect(result[i].uuid).to eq(data_source[:uuid])
        end
      end
    end

    describe "#create_data_source" do

      let(:name) { "New Data Source" }
      let(:data_source) { {
                            uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                            name: "In-house billing",
                            created_at: "2016-01-10 15:34:05",
                            status: "never_imported"
                        } }

      subject { client.create_data_source(name: name) }

      before(:each) do
        stub_request(:post, request_stub_path(credentials, "/import/data_sources"))
            .with(body: { name: name }.to_json)
            .to_return(body: data_source.to_json)
      end

      it "should return the created data source" do
        expect(subject.uuid).to eq(data_source[:uuid])
      end

      context "when name nil" do
        let(:name) { nil }

        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

    end

    describe "list_customers" do

      let(:customers) {[
                         {
                           uuid: "cus_f466e33d-ff2b-4a11-8f85-417eb02157a7",
                           data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                           external_id: "cus_0001",
                           name: "Adam Smith",
                           email: "adam@smith.com",
                           company: "",
                           country: "US",
                           state: "",
                           city: "New York",
                           zip: ""
                         },
                         {
                           uuid: "cus_ee325d54-7ab4-421b-cdb2-eb6b9e546034",
                           data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                           external_id: "cus_0002",
                           name: "Alice",
                           email: "alice@acme.com",
                           company: "Acme inc.",
                           country: "",
                           state: "",
                           city: "",
                           zip: ""
                         }
                          ]}
      before(:each) do
        stub_request(:get, request_stub_path(credentials, "/import/customers") + "?page_number=1")
          .to_return(status: 200, body: { customers: customers, current_page: 1, total_pages: 1 }.to_json)
      end

      subject { client.list_customers }

      it "should return all of the data sources" do
        result = subject
        customers.each_with_index do |customer, i|
          expect(result[i].uuid).to eq(customer[:uuid])
        end
      end
    end

    describe "#create_customer" do

      let(:args) {{
                    data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                    external_id: "cus_0001",
                    name: "Adam Smith",
                    email: "adam@smith.com",
                    country: "US",
                    city: "New York"
                   }}

      let(:customer) {{
                       uuid: "cus_f466e33d-ff2b-4a11-8f85-417eb02157a7",
                       data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                       external_id: "cus_0001",
                       name: "Adam Smith",
                       company: "",
                       email: "adam@smith.com",
                       city: "New York",
                       state: "",
                       country: "US",
                       zip: ""
                      }}

      subject { client.create_customer(args) }

      before(:each) do
        stub_request(:post, request_stub_path(credentials, "/import/customers"))
            .with(body: args.to_json)
            .to_return(body: customer.to_json)
      end

      it "should return the created customer" do
        expect(subject.uuid).to eq(customer[:uuid])
      end

      context "when missing data_source_uuid" do
        before(:each) do
          args.delete(:data_source_uuid)
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when missing external_id" do
        before(:each) do
          args.delete(:external_id)
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when missing name" do
        before(:each) do
          args.delete(:name)
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

    end

    describe "list_plans" do

      let(:plans) {[
                     {
                       uuid: "pl_eed05d54-75b4-431b-adb2-eb6b9e543206",
                       data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                       name: "Bronze Plan",
                       interval_count: 1,
                       interval_unit: "month",
                       external_id: "plan_0001"
                     },
                     {
                       uuid: "pl_cdb35d54-75b4-431b-adb2-eb6b9e873425",
                       data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                       name: "Silver Plan",
                       interval_count: 6,
                       interval_unit: "month",
                       external_id: "plan_0002"
                     },
                     {
                       uuid: "pl_ab225d54-7ab4-421b-cdb2-eb6b9e553462",
                       data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                       name: "Gold Plan",
                       interval_count: 1,
                       interval_unit: "year",
                       external_id: "plan_0003"
                     }
                    ]}
      before(:each) do
        stub_request(:get, request_stub_path(credentials, "/import/plans") + "?page_number=1")
          .to_return(status: 200, body: { plans: plans, current_page: 1, total_pages: 1 }.to_json)
      end

      subject { client.list_plans }

      it "should return all of the data sources" do
        result = subject
        plans.each_with_index do |plan, i|
          expect(result[i].uuid).to eq(plan[:uuid])
        end
      end
    end

    describe "#create_plan" do

      let(:args) {{
                   data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                   name: "Bronze Plan",
                   interval_count: 1,
                   interval_unit: :month,
                   external_id: "plan_0001"
                 }}

      let(:plan) {{
                   uuid: "pl_eed05d54-75b4-431b-adb2-eb6b9e543206",
                   data_source_uuid: "ds_fef05d54-47b4-431b-aed2-eb6b9e545430",
                   name: "Bronze Plan",
                   interval_count: 1,
                   interval_unit: "month",
                   external_id: "plan_0001"
                  }}

      subject { client.create_plan(args) }

      before(:each) do
        stub_request(:post, request_stub_path(credentials, "/import/plans"))
            .with(body: args.to_json)
            .to_return(body: plan.to_json)
      end

      it "should return the created plan" do
        expect(subject.uuid).to eq(plan[:uuid])
      end

      context "when missing data_source_uuid" do
        before(:each) do
          args.delete(:data_source_uuid)
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when missing interval_count" do
        before(:each) do
          args.delete(:interval_count)
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when missing name" do
        before(:each) do
          args.delete(:name)
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when interval_count not an integer" do
        before(:each) do
          args[:interval_count] = 123.0
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when interval_unit not :day, :month or :year" do
        before(:each) do
          args[:interval_unit] = :bilge
        end
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

  end
end
