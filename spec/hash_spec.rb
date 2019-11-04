# frozen_string_literal: true

RSpec.describe Apullo::Hash do
  subject { described_class.new "foo" }

  describe "mmh3" do
    it do
      expect(subject.mmh3).to eq(-156_908_512)
    end
  end

  describe "#sha1" do
    it do
      expect(subject.sha1).to eq("0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33")
    end
  end

  describe "#sha256" do
    it do
      expect(subject.sha256).to eq("2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae")
    end
  end

  describe "#md5" do
    it do
      expect(subject.md5).to eq("acbd18db4cc2f85cedef654fccc4a4d8")
    end
  end
end
