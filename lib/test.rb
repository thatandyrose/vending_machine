class Hello
  attr_reader :name
  def initialize(opts)
    @name = opts[:name]
  end
  def say
    "hello"
  end
end