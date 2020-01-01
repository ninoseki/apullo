# frozen_string_literal: true

RSpec.describe Apullo::CLI, :vcr do
  subject { described_class.new }

  context "when given a valid input" do
    let(:target) { Apullo::Target.new "example.com" }
    let(:mock) { instance_double("fingerprint") }

    before do
      allow(mock).to receive(:results).and_return({})
      allow(mock).to receive(:name).and_return("foo")

      allow(Apullo::Fingerprint::Domain).to receive(:new).and_return(mock)
      allow(Apullo::Fingerprint::Favicon).to receive(:new).and_return(mock)
      allow(Apullo::Fingerprint::HTTP).to receive(:new).and_return(mock)
      allow(Apullo::Fingerprint::SSH).to receive(:new).and_return(mock)

      allow(Parallel).to receive(:processor_count).and_return(0)
    end

    describe "#build_results" do
      it do
        res = subject.build_results(target)
        expect(res).to be_a(Hash)
      end
    end

    describe "#check" do
      it do
        expect { subject.check("example.com") }.to output.to_stdout
      end
    end
  end

  context "when given an invalid input" do
    let(:target) { Apullo::Target.new "foo" }

    describe "#build_results" do
      it do
        res = subject.build_results(target)
        expect(res.dig(:error)).to be_a(String)
      end
    end
  end
end
