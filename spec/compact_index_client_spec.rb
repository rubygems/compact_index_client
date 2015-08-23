require "spec_helper"

describe CompactIndexClient do
  it "has a version number" do
    expect(CompactIndexClient::VERSION).not_to be nil
  end

  let(:fetcher) { lambda {|_path, _headers| } }
  subject(:client) { described_class.new(directory, fetcher) }

  describe "#initialize" do
    it "has a directory" do
      expect(client.directory).to eq(directory)
    end
  end

  describe "#names" do
  end

  describe "#versions" do
  end

  describe "#dependencies" do
  end

  describe "#spec" do
  end

  describe "helper methods" do
    describe "#update" do
    end

    describe "#update_info" do
    end

    describe "#url" do
      it "returns the given path" do
      end
    end
  end
end
