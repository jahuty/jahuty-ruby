# frozen_string_literal: true

require 'securerandom'

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

    describe 'user renders one snippet' do
      context 'without parameters' do
        let(:render) { jahuty.snippets.render 1 }

        it 'renders the snippet' do
          expect(render).to have_attributes(
            content: '<p>This is my first snippet!</p>'
          )
        end

        it 'caches the render' do
          render

          expect { jahuty.snippets.render 1 }.to be_cache_hit
        end
      end

      context 'with parameters' do
        let(:params) { { foo: 'foo', bar: 'bar' } }
        let(:render) { jahuty.snippets.render 62, params: params }

        it 'renders the snippet' do
          expect(render).to have_attributes(
            content: '<p>This foo is bar.</p>'
          )
        end

        it 'caches the render' do
          render

          expect { jahuty.snippets.render 62, params: params }.to be_cache_hit

          params[:bar] = 'baz'
          expect { jahuty.snippets.render 62, params: params }.to be_cache_miss
        end
      end

      context 'with latest content' do
        let(:render) { jahuty.snippets.render 102, prefer_latest: 1 }

        it 'renders the snippet' do
          expect(render).to have_attributes(
            content: '<p>This content is latest.</p>'
          )
        end
      end

      context 'with a problem' do
        it 'raises error' do
          expect { jahuty.snippets.render(999) }.to raise_error(Exception::Error)
        end
      end
    end

    describe '#all_renders' do
      context 'without parameters' do
        let(:renders) { jahuty.snippets.all_renders 'test' }

        it 'renders the collection' do
          expect(renders).to include(
            an_object_having_attributes(content: '<p>This is my first snippet!</p>'),
            an_object_having_attributes(content: '<p>This  is .</p>'),
            an_object_having_attributes(content: '<p>This content is published.</p>')
          )
        end

        it 'caches the renders' do
          renders

          expect { jahuty.snippets.render 1 }.to be_cache_hit
          expect { jahuty.snippets.render 62 }.to be_cache_hit
          expect { jahuty.snippets.render 102 }.to be_cache_hit
        end
      end

      context 'with parameters' do
        let(:params) { { '*' => { foo: 'foo' }, '62' => { bar: 'bar' } } }
        let(:renders) { jahuty.snippets.all_renders 'test', params: params }

        it 'renders the collection' do
          expect(renders).to include(
            an_object_having_attributes(content: '<p>This is my first snippet!</p>'),
            an_object_having_attributes(content: '<p>This foo is bar.</p>'),
            an_object_having_attributes(content: '<p>This content is published.</p>')
          )
        end

        it 'caches the renders' do
          renders

          params = { foo: 'foo' }
          expect { jahuty.snippets.render 1, params: params }.to be_cache_hit

          params = { foo: 'foo', bar: 'bar' }
          expect { jahuty.snippets.render 62, params: params }.to be_cache_hit

          params = { foo: 'qux', bar: 'quux' }
          expect { jahuty.snippets.render 62, params: params }.to be_cache_miss
        end
      end

      context 'with latest content' do
        let(:render) { jahuty.snippets.all_renders 'test', prefer_latest: 1 }

        it 'renders the snippet' do
          expect(render).to include(
            an_object_having_attributes(content: '<p>This content is latest.</p>')
          )
        end
      end

      context 'with a problem' do
        let(:tag) { SecureRandom.hex(8) }  # Hopefully, a tag we never use.

        it 'raises error' do
          expect { jahuty.snippets.all_renders(tag) }.to raise_error(Exception::Error)
        end
      end
    end
  end
end
