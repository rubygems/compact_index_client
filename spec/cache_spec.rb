require "spec_helper"

describe CompactIndexClient::Cache do
  subject(:cache) { described_class.new(directory) }

  def write(path, contents)
    path.open("w") {|f| f << contents }
  end

  describe "#initialize" do
    it "has a directory" do
      expect(cache.directory).to eq(directory)
    end

    it "creates the directory if it doesn't exist" do
      directory.rmtree if directory.directory?
      cache
      expect(directory).to be_a_directory
    end

    it "doesnt delete the directory if it exists" do
      directory.mkpath
      write(directory + "foo", "")
      cache
      expect(directory + "foo").to be_a_file
    end
  end

  describe "paths" do
    it "has a names path" do
      expect(cache.names_path).to eq(directory + "names")
    end

    it "has a versions path" do
      expect(cache.versions_path).to eq(directory + "versions")
    end

    it "has info paths" do
      expect(cache.info_path("foo")).to eq(directory + "info/foo")
    end
  end

  describe "#names" do
    let(:names) { %w(foo bar baz quz) }

    it "parses out names" do
      write(cache.names_path, names.join("\n"))
      expect(cache.names).to eq(names)
    end

    it "ignores a leading comment" do
      write(cache.names_path, "foo\n---\n" << names.join("\n"))
      expect(cache.names).to eq(names)
    end
  end

  describe "#versions" do
  end

  describe "#dependencies" do
  end

  describe "#specific_dependency" do
  end
end
