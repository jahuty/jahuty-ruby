module Jahuty
  RSpec.describe Service::Get do
    describe "#call" do
      let(:response) do
        response = instance_double(::Faraday::Response)

        allow(response).to receive(:status).and_return(status)
        allow(response).to receive(:body).and_return(body)

        return response
      end

      let(:connection) do
        connection = instance_double(::Faraday::Connection)

        allow(connection).to receive(:get).and_return(response)

        return connection
      end

      let(:body) { '{ "status": 1, "type": "foo", "detail": "bar" }' }

      subject { Service::Get.new(connection) }

      context "when the response's status code is 401" do
        let(:status) { 401 }

        it "raises error" do
          expect{ subject.call(1) }.to raise_error(Exception::NotOk)
        end
      end

      context "when the response's status code is 404" do
        let(:status) { 404 }

        it "raises error" do
          expect{ subject.call(1) }.to raise_error(Exception::NotOk)
        end
      end

      context "when the response's status code is 5XX" do
        let(:status) { 500 }

        it "raises error" do
          expect{ subject.call(1) }.to raise_error(Exception::NotOk)
        end
      end

      context "when the response's status code is 200" do
        let(:status) { 200 }
        let(:body)   { '{"id": 1, "content": "foo"}' }

        it "returns a snippet" do
          expect(subject.call(1)).to be_instance_of(Data::Snippet)
        end
      end
    end
  end
end
