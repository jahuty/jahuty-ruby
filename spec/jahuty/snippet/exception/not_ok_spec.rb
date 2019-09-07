module Jahuty
  module Snippet
    module Exception
      RSpec.describe NotOk do
        describe "#message" do
          it "returns message with problem's status, title, and detail" do
            status = 1
            title  = "foo"
            detail = "bar"

            problem = ::Jahuty::Snippet::Data::Problem.new(status, title, detail)
            subject = NotOk.new(problem)

            expect(subject.message).to include(status.to_s, title, detail)
          end
        end
      end
    end
  end
end
