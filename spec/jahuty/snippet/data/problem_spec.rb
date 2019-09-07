module Jahuty
  module Snippet
    module Data
      RSpec.describe Problem do
        describe ".from" do
          let(:data) { { status: 1, type: "foo", detail: "bar" } }

          it "raises error if :status key does not exist" do
            data.delete(:status)

            expect{ Problem.from(data) }.to raise_error(ArgumentError)
          end

          it "raises error if :type key does not exist" do
            data.delete(:type)

            expect{ Problem.from(data) }.to raise_error(ArgumentError)
          end

          it "raises error if :detail key does not exist" do
            data.delete(:detail)

            expect{ Problem.from(data) }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
