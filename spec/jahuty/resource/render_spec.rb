module Jahuty
  module Resource
    RSpec.describe Render do
      let(:content) { "foo" }

      subject(:render) { Render.new(content: "foo") }

      describe "#initialize" do
        it "sets content" do
          expect(render.content).to eq(content)
        end
      end

      describe "#to_s" do
        it "returns content" do
          expect(render.to_s).to eq(content)
        end
      end
    end
  end
end
