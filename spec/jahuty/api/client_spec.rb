module Jahuty
  module Api
    RSpec.describe Client do
      describe "#send" do
        let(:api_key) { "foo" }
        let(:version) { ::Jahuty::VERSION }

        before do
          stub_request(:get, "https://api.jahuty.com/foo").
            with(
              headers: {
                'Accept'          =>'application/json;q=0.9,*/*;q=0.8',
                'Accept-Encoding' =>'gzip, deflate',
                'Authorization'   =>"Bearer #{api_key}",
                'Content-Type'    =>'application/json; charset=utf-8',
                'User-Agent'      =>"Jahuty Ruby SDK v#{version}"
              }).
            to_return(status: 200, body: '{"foo":"bar"}', headers: {})
        end

        it "returns response" do
          request = ::Jahuty::Request::Base.new(method: "get", path: "foo")

          client = Client.new(api_key: api_key)

          expect(client.send(request)).to have_attributes(
            status:  200,
            body:   '{"foo":"bar"}',
            headers: {}
          )
        end
      end
    end
  end
end
