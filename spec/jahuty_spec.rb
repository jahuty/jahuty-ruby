RSpec.describe Jahuty do
  before { Jahuty.key = nil }
  after  { Jahuty.key = nil }

  it "has a version number" do
    expect(Jahuty::VERSION).not_to be nil
  end

  describe "::key?" do
    it "returns true if key exists" do
      Jahuty.key = "foo"

      expect(Jahuty.key?).to be_truthy
    end

    it "returns false if key does not exist" do
      expect(Jahuty.key?).to be_falsy
    end
  end
end
