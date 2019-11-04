# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::Base, :vcr do
  subject { described_class.new target }

  let(:id) { "example.com" }
  let(:target) { Apullo::Target.new id }

  describe "#name" do
    it do
      expect(subject.name).to eq("base")
    end
  end

  describe "#results" do
    it do
      expect { subject.results }.to raise_error(NotImplementedError)
    end
  end
end
