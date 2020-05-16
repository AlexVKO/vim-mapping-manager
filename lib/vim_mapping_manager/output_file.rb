require 'tempfile'

class OutputFile
  @tempfile = ::Tempfile.new()

  def self.write(content)
    @tempfile << content + "\n"
  end

  def self.output
    @tempfile.rewind
    @tempfile.read
  end

  def self.reset!
    @tempfile = ::Tempfile.new()
  end
end
