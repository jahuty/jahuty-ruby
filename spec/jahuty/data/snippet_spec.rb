module Jahuty
  module Data
    RSpec.describe Snippet do
      describe ".from" do
        let(:data) { { id: 1, content: "foo" } }

        it "raises error if :id key does not exist" do
          data.delete(:id)

          expect{ Snippet.from(data) }.to raise_error(ArgumentError)
        end

        it "raises error if :content key does not exist" do
          data.delete(:content)

          expect{ Snippet.from(data) }.to raise_error(ArgumentError)
        end
      end

      describe "#to_s" do
        it "returns content" do
          expect(Snippet.new(1, "foo").to_s).to eq("foo")
        end
      end
    end
  end
end
