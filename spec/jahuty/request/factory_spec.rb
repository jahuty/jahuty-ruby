module Jahuty
  module Request
    RSpec.describe Factory do
      describe "#call" do
        let(:action) { ::Jahuty::Action::Show.new(id: 1, resource: "foo") }

        subject(:factory) { Factory.new }

        it "returns request" do
          expect(factory.call(action)).to be_instance_of(Base)
        end
      end
    end
  end
end
