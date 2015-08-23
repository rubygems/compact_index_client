require "spec_helper"

describe CompactIndexClient::Updater do
  let(:fetcher) { lambda {|_path, _headers| } }
  subject(:updater) { described_class.new(fetcher) }

  describe "#initialize" do
  end

  describe "#update" do
  end

  describe "#checksum_for_file" do
    require "tempfile"

    it "returns nil when the file doesn't exist" do
      expect(updater.checksum_for_file(Pathname.new("foo"))).to be_nil
    end

    it "returns the file's checksum" do
      Tempfile.open("f") do |f|
        f << "foobar"
        expect(updater.checksum_for_file(Pathname.new f)).to eq("d41d8cd98f00b204e9800998ecf8427e")
      end
    end
  end
end
