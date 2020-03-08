module Jahuty
  module Service
    RSpec.describe Connect do
      describe "#call" do
        it "returns a connection" do
          expect(subject.call("foo")).to be_instance_of(Faraday::Connection)
        end
      end
    end
  end
end
