# frozen_string_literal: true

module Jahuty
  module Api
    RSpec.describe Client do
      describe '#send' do
        subject(:client) { described_class.new(api_key: api_key) }

        let(:api_key) { 'foo' }
        let(:version) { ::Jahuty::VERSION }
        let(:request) { ::Jahuty::Request::Base.new(method: 'get', path: 'foo') }

        before do
          stub_request(:get, 'https://api.jahuty.com/foo')
            .with(
              headers: {
                'Accept' => 'application/json;q=0.9,*/*;q=0.8',
                'Accept-Encoding' => 'gzip, deflate',
                'Authorization' => "Bearer #{api_key}",
                'Content-Type' => 'application/json; charset=utf-8',
                'User-Agent' => "Jahuty Ruby SDK v#{version}"
              }
            )
            .to_return(status: 200, body: '{"foo":"bar"}', headers: {})
        end

        it 'returns response' do
          expect(client.send(request)).to have_attributes(
            status: 200,
            body: '{"foo":"bar"}',
            headers: {}
          )
        end
      end
    end
  end
end
