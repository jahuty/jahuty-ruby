# frozen_string_literal: true

module Jahuty
  RSpec.describe Client do
    before { WebMock.enable_net_connect! }

    after { WebMock.disable_net_connect! }

    describe 'when snippet exists' do
      let(:client) do
        described_class.new(
          api_key: 'kn2Kj5ijmT2pH6ZKqAQyNexUqKeRM4VG6DDgWN1lIcc'
        )
      end

      it 'returns content' do
        expect(client.snippets.render(1)).to have_attributes(
          content: '<p>This is my first snippet!</p>'
        )
      end
    end

    describe 'when snippet is requested many times' do
      let(:client) do
        described_class.new(
          api_key: 'kn2Kj5ijmT2pH6ZKqAQyNexUqKeRM4VG6DDgWN1lIcc'
        )
      end

      before { client.snippets.render 1 }

      it 'uses cache' do
        start1 = Time.now
        client.snippets.render 1
        end1 = Time.now

        expect((end1 - start1) * 1000).to be < 1
      end
    end
  end
end
