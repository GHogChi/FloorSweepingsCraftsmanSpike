require 'lib/constituent'

class ConstituentExtractor
  
  attr_writer = :start_matcher, :end_matcher
#  def initialize(start_matcher, end_matcher)
  def initialize(start_pattern, end_pattern, eos_pattern)
#    @start_matcher = start_matcher
#    @end_matcher = end_matcher
    @start_matcher = Proc.new do
      |str| 
      m = str.match /(#{start_pattern})/
    end
    @end_matcher = Proc.new do
      |str| 
      m = str.match /(#{end_pattern})|(#{eos_pattern})/
    end
    
  end
  
  def extract(str, offset)
    results = []
    begin
      substr = str[offset..-1]
      if constituent = extract_one(substr) 
        results << constituent 
        offset += (constituent.offset + constituent.contents.size)
      end
    end until constituent == nil
    results
  end
  
  private
  def extract_one(str)
    constituent = nil
    start = @start_matcher.call(str)
    if start 
      tail = str[start.end(1)..-1]
      end_match = @end_matcher.call(tail)
      if end_match
        print "end_match captures: #{end_match.captures.size}<br>"
        end_match.captures.size.times {|i| puts "match[i]: '#{end_match.captures[i]}'<br>"}
        starting_offset = start.begin(1)
        end_match_index = end_match.captures[0] ? end_match.begin(1) : end_match.begin(2)
        ending_offset = start.end(1) + end_match_index
        contents = str[starting_offset...ending_offset]
        tipoff = start[0]
        constituent = Constituent.new(starting_offset, contents, tipoff)
      end
    end
    constituent
  end
  
end