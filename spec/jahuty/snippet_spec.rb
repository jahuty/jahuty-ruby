RSpec.describe Jahuty::Snippet do
  it "has a version number" do
    expect(Jahuty::Snippet::VERSION).not_to be nil
  end

  describe ".get" do
    context "when key is not set" do
      it "raises error" do
        expect{ subject.get(1) }.to raise_error(StandardError)
      end
    end

    context "when key is set" do
      before { Jahuty::Snippet.key = '78e202009659616eceed79c01a75bfe9' }

      it "returns content" do
        expect(Jahuty::Snippet.get(1)).to eq('This is my first snippet!')
      end
    end
  end
end
