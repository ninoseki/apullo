# frozen_string_literal: true

RSpec.describe Apullo::Target do
  context "when given a URL" do
    subject { described_class.new id }

    let(:id) { "http://example.com" }

    describe "#host" do
      it do
        expect(subject.host).to eq("example.com")
      end
    end

    describe "#valid?" do
      it do
        expect(subject.valid?).to eq(true)
      end
    end
  end

  context "when given a domain" do
    subject { described_class.new id }

    let(:id) { "example.com" }

    describe "#host" do
      it do
        expect(subject.host).to eq("example.com")
      end
    end

    describe "#url" do
      it do
        expect(subject.url).to eq("http://example.com")
      end
    end

    describe "#valid?" do
      it do
        expect(subject.valid?).to eq(true)
      end
    end
  end

  context "when given an ip" do
    subject { described_class.new id }

    let(:id) { "1.1.1.1" }

    describe "#host" do
      it do
        expect(subject.host).to eq("1.1.1.1")
      end
    end

    describe "#url" do
      it do
        expect(subject.url).to eq("http://1.1.1.1")
      end
    end

    describe "#valid?" do
      it do
        expect(subject.valid?).to eq(true)
      end
    end
  end

  context "when given an invalid input" do
    describe "#valid?" do
      it do
        subject = described_class.new "999.999.999.999"
        expect(subject.valid?).to eq(false)
      end

      it do
        subject = described_class.new "ftp://1.1.1.1"
        expect(subject.valid?).to eq(false)
      end

      it do
        subject = described_class.new "foo.bar.fooooooo"
        expect(subject.valid?).to eq(false)
      end
    end
  end
end
