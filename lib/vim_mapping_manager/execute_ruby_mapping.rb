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
    key = remove_special_chars(key)
    name = [key, filetype].compact.join('_').to_s
    raise("Ruby command already defined with #{name}") if @commands[name]
    @commands[name] = proc
    ":call #{FUNCTION_NAME}('#{key}', '#{filetype || 'all'}')"
  end

  def self.fetch(key, filetype = nil)
    key = remove_special_chars(key)
    filetype = nil if filetype == 'all'
    name = [key, filetype].compact.join('_').to_s
    @commands[name]
  end

  def self.remove_special_chars(key)
    key.gsub(/[^0-9A-Za-z]/, '')
  end
end

