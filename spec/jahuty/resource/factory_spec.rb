module Jahuty
  module Resource
    RSpec.describe Factory do
      describe "#call" do
        # A valid action.
        let(:action) { ::Jahuty::Action::Show.new(id: 1, resource: "render") }

        subject(:factory) { Factory.new }

        context "with the requested resource" do
          let(:response) do
            response = instance_double("::Faraday::Response")

            allow(response).to receive(:status).and_return(200)
            allow(response).to receive(:body).and_return('{"content":"foo"}')

            response
          end

          it "returns render" do
            expect(factory.call(action, response)).to be_instance_of(Render)
          end
        end

        context "with invalid json" do
          let(:response) do
            response = instance_double("::Faraday::Response")

            allow(response).to receive(:status).and_return(200)
            allow(response).to receive(:body).and_return("invalid json")

            response
          end

          it "raises error" do
            expect {
              factory.call(action, response)
            }.to raise_error(JSON::ParserError)
          end
        end

        context "with a problem resource" do
          let(:response) do
            headers = instance_double("::Faraday::Headers")

            # The Content-Type header indicates a problem resource.
            allow(headers).to receive(:[]).with("Content-Type").
              and_return("application/problem+json")

            response = instance_double("::Faraday::Response")

            allow(response).to receive(:status).and_return(404)
            allow(response).to receive(:headers).and_return(headers)
            allow(response).to receive(:body).and_return(
              '{"status": 200, "type": "foo", "detail": "bar" }'
            )

            response
          end

          it "returns problem" do
            expect(factory.call(action, response)).to be_instance_of(Problem)
          end
        end

        context "with an invalid resource" do
          let(:response) do
            headers = instance_double("::Faraday::Headers")

            # Use any Content-Type, except application/problem+json.
            allow(headers).to receive(:[]).with("Content-Type").
              and_return("text/plain")

            response = instance_double("::Faraday::Response")

            # Use any status code outside of 2xx range.
            allow(response).to receive(:status).and_return(404)
            allow(response).to receive(:headers).and_return(headers)
            allow(response).to receive(:body).and_return("a fatal error")

            response
          end

          it "raises error" do
            expect {
              factory.call(action, response)
            }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
