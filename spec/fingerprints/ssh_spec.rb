# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::SSH do
  subject { described_class.new target }

  let(:id) { "1.1.1.1" }
  let(:target) { Apullo::Target.new id }
  let(:mock) { instance_double("doubleSSHScan") }

  describe "#results" do
    before do
      allow(mock).to receive(:scan_target).with("1.1.1.1:22", "timeout" => 3).and_return({})
      allow(SSHScan::ScanEngine).to receive(:new).and_return(mock)
    end

    it do
      results = subject.results
      expect(results).to be_a(Hash)
    end
  end
end
