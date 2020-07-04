module Jahuty
  RSpec.describe Snippet do
    describe "::render" do
      before { Jahuty.key = 'kn2Kj5ijmT2pH6ZKqAQyNexUqKeRM4VG6DDgWN1lIcc' }

      it "returns content" do
        expect(Snippet.render(1)).to have_attributes({
          content: "This is my first snippet!"
        })
      end
    end
  end
end
