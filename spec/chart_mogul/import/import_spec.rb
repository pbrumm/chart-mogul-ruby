require 'spec_helper'

module ChartMogul
  module Import
    describe Invoice do

      describe "#initialize" do
        let(:args) { {
                        uuid: "inv_565c73b2-85b9-49c9-a25e-2b7df6a677c9",
                        external_id: "INV0001",
                        date: "2015-11-01T00:00:00.000Z",
                        due_date: "2015-11-15T00:00:00.000Z",
                        currency: "USD",
                        line_items: [
                          {
                            uuid: "li_d72e6843-5793-41d0-bfdf-0269514c9c56",
                            external_id: nil,
                            type: "subscription",
                            subscription_uuid: "sub_e6bc5407-e258-4de0-bb43-61faaf062035",
                            plan_uuid: "pl_eed05d54-75b4-431b-adb2-eb6b9e543206",
                            prorated: false,
                            service_period_start: "2015-11-01T00:00:00.000Z",
                            service_period_end: "2015-12-01T00:00:00.000Z",
                            amount_in_cents: 5000,
                            quantity: 1,
                            discount_code: "PSO86",
                            discount_amount_in_cents: 1000,
                            tax_amount_in_cents: 900
                          },
                          {
                            uuid: "li_0cc8c112-beac-416d-af11-f35744ca4e83",
                            external_id: nil,
                            type: "one_time",
                            description: "Setup Fees",
                            amount_in_cents: 2500,
                            quantity: 1,
                            discount_code: "PSO86",
                            discount_amount_in_cents: 500,
                            tax_amount_in_cents: 450
                          }
                        ],
                        transactions: [
                          {
                            uuid: "tr_879d560a-1bec-41bb-986e-665e38a2f7bc",
                            external_id: nil,
                            type: "payment",
                            date: "2015-11-05T00:14:23.000Z",
                            result: "successful"
                          }
                        ]
                      } }
        subject { Invoice.new(args) }

        it "should set uuid" do
          expect(subject.uuid).to eq(args[:uuid])
        end

        it "should load line_items" do
          result = subject
          expect(result.line_items.count).to eq(args[:line_items].count)
          result.line_items.each_with_index do |line_item, i|
            expect(line_item.uuid).to eq(args[:line_items][i][:uuid])
          end
        end

        it "should load transactions" do
          result = subject
          expect(result.transactions.count).to eq(args[:transactions].count)
          result.transactions.each_with_index do |transaction, i|
            expect(transaction.uuid).to eq(args[:transactions][i][:uuid])
          end
        end
      end
    end
  end
end