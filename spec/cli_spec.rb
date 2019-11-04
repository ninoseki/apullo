# frozen_string_literal: true

RSpec.describe Apullo::CLI do
  subject { described_class.new }

  describe "build_results" do
    context "when given an invalid input" do
      let(:target) { Apullo::Target.new "foo" }

      it do
        res = subject.build_results(target)
        expect(res.dig(:error)).to be_a(String)
      end
    end
  end
end
