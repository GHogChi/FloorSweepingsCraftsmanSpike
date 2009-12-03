class Constituent
  attr_accessor = :offset, :tipoff, :contents
  
  def initialize(offset, contents, tipoff) 
    @offset = offset
    @contents = contents
    @tipoff = tipoff
  end
  
  def offset; @offset; end
  def tipoff; @tipoff; end  
  def contents; @contents; end
  
end