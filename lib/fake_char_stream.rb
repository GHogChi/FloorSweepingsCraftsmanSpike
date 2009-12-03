class FakeCharacterStream
  def initialize(chars)
    @data = chars
  end
  
  def each
    while ch = @data.slice!(0)
      yield(ch)
    end
  end
end

