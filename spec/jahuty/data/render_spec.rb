module Jahuty
  module Data
    RSpec.describe Render do
      describe ".from" do
        let(:data) { { content: "foo" } }

        it "raises error if :content key does not exist" do
          data.delete(:content)

          expect{ Render.from(data) }.to raise_error(ArgumentError)
        end
      end

      describe "#to_s" do
        it "returns content" do
          expect(Render.new("foo").to_s).to eq("foo")
        end
      end
    end
  end
end
