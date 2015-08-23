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

  describe "helper methods" do
    describe "#lines" do
      def lines(path)
        cache.send(:lines, path)
      end

      it "parses out the lines" do
        path = directory + "foo"
        write(path, "a\nb\n---\nc   \n d\ne\n")
        expect(lines(path)).to eq %w(c d e)
      end

      it "allows a --- after the header separator" do
        path = directory + "foo"
        write(path, "a\n---\nb\n---\n")
        expect(lines(path)).to eq %w(b ---)
      end
    end

    describe "#parse_gem" do
      def parse_gem(string)
        cache.send(:parse_gem, string)
      end

      it "parses a gem version" do
        string = "0.34.0-foo bar:>= 0,baz:<= 10&>3|ruby:>=2.0"
        expected = ["0.34.0",
                    "foo",
                    [["bar", [">= 0"]], ["baz", ["<= 10", ">3"]]],
                    [["ruby", [">=2.0"]]]]
        expect(parse_gem(string)).to eq(expected)
      end

      it "can handle a default platform" do
        string = "0.34.0 bar:>= 0,baz:<= 10&>3|ruby:>=2.0"
        expected = ["0.34.0",
                    nil,
                    [["bar", [">= 0"]], ["baz", ["<= 10", ">3"]]],
                    [["ruby", [">=2.0"]]]]
        expect(parse_gem(string)).to eq(expected)
      end

      it "can handle no dependencies" do
        string = "0.34.0-foo |ruby:>=2.0"
        expected = ["0.34.0", #
                    "foo",
                    [],
                    [["ruby", [">=2.0"]]]]
        expect(parse_gem(string)).to eq(expected)
      end

      it "can handle no requirements" do
        string = "0.34.0-foo bar:>= 0,baz:<= 10&>3|"
        expected = ["0.34.0",
                    "foo",
                    [["bar", [">= 0"]], ["baz", ["<= 10", ">3"]]],
                    []]
        expect(parse_gem(string)).to eq(expected)
      end
    end

    describe "#parse_dependency" do
      def parse_dependency(string)
        cache.send(:parse_dependency, string)
      end

      it "parses a dependency" do
        string = "baz:<= 10&>3"
        expected = ["baz", ["<= 10", ">3"]]
        expect(parse_dependency(string)).to eq(expected)
      end

      it "can handle when there are no requirements" do
        string = "baz:"
        expected = ["baz"]
        expect(parse_dependency(string)).to eq(expected)

        string = "baz"
        expect(parse_dependency(string)).to eq(expected)
      end
    end
  end
end
