$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "compact_index_client"
require "tmpdir"

RSpec.configure do |c|
  def directory
    @directory
  end

  c.before(:each) do
    @directory = Pathname.new(Dir.mktmpdir)
  end

  c.after(:each) do
    directory.rmtree if directory.directory?
  end
end
