module Jahuty
  RSpec.describe 'System tests' do
    before { WebMock.enable_net_connect! }

    after { WebMock.disable_net_connect! }

    describe 'when snippet exists' do
      let(:client) do
        Client.new(api_key: 'kn2Kj5ijmT2pH6ZKqAQyNexUqKeRM4VG6DDgWN1lIcc')
      end

      it 'returns content' do
        expect(client.snippets.render(1)).to have_attributes({
          content: '<p>This is my first snippet!</p>'
        })
      end
    end
  end
end
