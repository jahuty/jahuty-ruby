# frozen_string_literal: true

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

        # Rendering the snippet again should use the cached value.
        time = timer { jahuty.snippets.render 1 }
        expect(time).to be < 1
      end
    end

    describe 'user renders snippet with parameters' do
      it 'renders the snippet' do
        params = { foo: 'foo', bar: 'bar' }

        render = jahuty.snippets.render 62, params: params

        expect(render).to have_attributes(
          content: '<p>This foo is bar.</p>'
        )

        # Rendering the snippet again with the _same_ params should use the
        # cached value.
        time = timer { jahuty.snippets.render 62, params: params }
        expect(time).to be < 1

        # Rendering the snippet again with _different_ params should send a
        # network request.
        params[:bar] = 'baz'
        time = timer { jahuty.snippets.render 62, params: params }
        expect(time).to be > 10
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

        # Rendering a snippet in the collection with the _same_ params should
        # use the cached value.
        time = timer { jahuty.snippets.render 1, params: { foo: 'foo' } }
        expect(time).to be < 1

        time = timer { jahuty.snippets.render 62, params: { foo: 'foo', bar: 'bar' } }
        expect(time).to be < 1

        # Rendering a snippet in the collection with _different_ params should
        # send a network request.
        time = timer { jahuty.snippets.render 62, params: { foo: 'qux', bar: 'quux' } }
        expect(time).to be > 10
      end
    end

    private

    def timer(&block)
      one = Time.now
      yield block
      two = Time.now

      (two - one) * 1000
    end
  end
end
