require 'tempfile'

class OutputFile
  @tempfile = ::Tempfile.new()

  def self.write(content)
    return unless content
    content = "" if content.strip.empty?
    @tempfile << content + "\n"
  end

  def self.output
    @tempfile.rewind
    @tempfile.read
  end

  def self.reset!
    @tempfile = ::Tempfile.new()
  end

  def self.save
    configuration_path = File.expand_path('~/.config/nvim/managed_mappings.vimrc')
    File.open(configuration_path, 'w+') { |file| file.write(output) }
  end
end
