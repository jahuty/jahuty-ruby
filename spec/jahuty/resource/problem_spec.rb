module Jahuty
  module Resource
    RSpec.describe Problem do
      describe ".from" do
        let(:payload) { { status: 1, type: "foo", detail: "bar" } }

        it "raises error if :status does not exist" do
          payload.delete(:status)

          expect{ Problem.from(payload) }.to raise_error(ArgumentError)
        end

        it "raises error if :type does not exist" do
          payload.delete(:type)

          expect{ Problem.from(payload) }.to raise_error(ArgumentError)
        end

        it "raises error if :detail does not exist" do
          payload.delete(:detail)

          expect{ Problem.from(payload) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
