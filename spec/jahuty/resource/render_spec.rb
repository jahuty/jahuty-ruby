module Jahuty
  module Resource
    RSpec.describe Render do
      describe ".from" do
        let(:payload) { { content: "foo" } }

        it "raises error if :content key does not exist" do
          payload.delete(:content)

          expect{ Render.from(payload) }.to raise_error(ArgumentError)
        end
      end

      describe "#to_s" do
        it "returns content" do
          expect(Render.new(content: "foo").to_s).to eq("foo")
        end
      end
    end
  end
end
