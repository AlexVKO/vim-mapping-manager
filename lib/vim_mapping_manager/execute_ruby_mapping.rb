class ExecuteRubyMapping
  FUNCTION_NAME = 'ExecuteRubyMapping'

  @commands = {}

  def self.reset!
    @commands = {}
  end

  def self.commands
    @commands
  end

  def self.set(key, filetype, proc)
    name = [key, filetype].compact.join('_').to_s
    @commands[name] = proc
    ":call #{FUNCTION_NAME}('#{key}', '#{filetype || 'all'}')"
  end

  def self.fetch(key, filetype = nil)
    filetype = nil if filetype == 'all'
    name = [key, filetype].compact.join('_').to_s
    @commands[name]
  end
end

