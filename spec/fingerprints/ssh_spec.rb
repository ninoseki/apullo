# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::SSH do
  subject { described_class.new target }

  let(:id) { "1.1.1.1" }
  let(:target) { Apullo::Target.new id }
  let(:mock) { instance_double("doubleSSHScan") }
  let(:scan_results) { JSON.parse File.read(File.expand_path("../fixtures/ssh.json", __dir__)) }

  describe "#results" do
    before do
      allow(mock).to receive(:scan_target).with("1.1.1.1:22", "timeout" => 3).and_return(scan_results)
      allow(SSHScan::ScanEngine).to receive(:new).and_return(mock)
    end

    let(:results) { subject.results }

    it do
      expect(results).to be_a(Hash)
    end

    it do
      %w(rsa ecdsa-sha2-nistp256 ed25519).each do |key|
        expect(results.dig(key)).to be_a(Hash)
      end
    end

    it do
      expect(results.dig(:meta, :links, :shodan)).to eq("https://www.shodan.io/search?query=port%3A22+c9%3A91%3A4f%3A48%3A43%3A2f%3A83%3A66%3Acc%3A22%3Ad3%3A57%3Ab2%3A69%3A40%3A7a")
    end

    it do
      expect(results.dig(:meta, :links, :censys)).to eq("https://censys.io/ipv4?q=541fcda6421a72456271c777cc482a64c09b52bc00199edf0773a2f7f4382bef")
    end

    context "when 22 port is closed" do
      before do
        allow(mock).to receive(:scan_target).with("1.1.1.1:22", "timeout" => 3).and_return({})
        allow(mock).to receive(:scan_target).with("1.1.1.1:2222", "timeout" => 3).and_return(scan_results)
        allow(SSHScan::ScanEngine).to receive(:new).and_return(mock)
      end

      it do
        results = subject.results
        %w(rsa ecdsa-sha2-nistp256 ed25519).each do |key|
          expect(results.dig(key)).to be_a(Hash)
        end
      end
    end
  end
end
