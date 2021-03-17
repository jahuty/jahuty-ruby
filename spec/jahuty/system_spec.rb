# frozen_string_literal: true

RSpec::Matchers.define :be_cache_hit do
  match do |actual|
    one = Time.now
    actual.call
    two = Time.now

    (two - one) * 1000 < 1
  end

  description { 'be a cache hit' }

  def supports_block_expectations?
    true
  end
end

RSpec::Matchers.define :be_cache_miss do
  match do |actual|
    one = Time.now
    actual.call
    two = Time.now

    (two - one) * 1000 > 10
  end

  description { 'be a cache miss' }

  def supports_block_expectations?
    true
  end
end

module Jahuty
  RSpec.describe Client do
    let(:jahuty) do
      described_class.new(
        api_key: 'kn2Kj5ijmT2pH6ZKqAQyNexUqKeRM4VG6DDgWN1lIcc'
      )
    end

    before { WebMock.enable_net_connect! }

    after { WebMock.disable_net_connect! }

    describe 'user renders snippet without parameters' do
      it 'renders the snippet' do
        render = jahuty.snippets.render 1

        expect(render).to have_attributes(
          content: '<p>This is my first snippet!</p>'
        )

        expect { jahuty.snippets.render 1 }.to be_cache_hit
      end
    end

    describe 'user renders snippet with parameters' do
      it 'renders the snippet' do
        params = { foo: 'foo', bar: 'bar' }

        render = jahuty.snippets.render 62, params: params

        expect(render).to have_attributes(
          content: '<p>This foo is bar.</p>'
        )

        expect { jahuty.snippets.render 62, params: params }.to be_cache_hit

        params[:bar] = 'baz'
        expect { jahuty.snippets.render 62, params: params }.to be_cache_miss
      end
    end

    describe 'user renders collection' do
      it 'renders the collection' do
        renders = jahuty.snippets.all_renders 'test', params: {
          '*' => { foo: 'foo' },
          '62' => { bar: 'bar' }
        }

        expect(renders.count).to be(2)
        expect(renders).to include(
          an_object_having_attributes(content: '<p>This is my first snippet!</p>'),
          an_object_having_attributes(content: '<p>This foo is bar.</p>')
        )

        expect {
          jahuty.snippets.render 1, params: { foo: 'foo' }
        }.to be_cache_hit

        expect {
          jahuty.snippets.render 62, params: { foo: 'foo', bar: 'bar' }
        }.to be_cache_hit

        expect {
          jahuty.snippets.render 62, params: { foo: 'qux', bar: 'quux' }
        }.to be_cache_miss
      end
    end

    describe 'user has problem' do
      it 'raises error' do
        expect { jahuty.snippets.render(999) }.to raise_error(Exception::Error)
      end
    end
  end
end
