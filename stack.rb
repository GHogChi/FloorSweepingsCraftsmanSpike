class Stack

  def initialize
   @the_stack = []
  end

  def push(item)
    @the_stack.push item
  end

  def pop
    @the_stack.pop
  end

  def count
    @the_stack.length
  end

  def clear
    @the_stack.clear
  end

  def poppable
    @the_stack.last
  end
  
  def each
    @the_stack.each {|e| yield(e)}
  end
    
end