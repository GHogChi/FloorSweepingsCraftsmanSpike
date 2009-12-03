require 'log4r'
require 'lib/loggable'
include Log4r


class Element
  include Loggable
  
  attr_accessor :tag, :contents, :complete
  
  def initialize (tag)
    @log = get_filelogger('logs')
    @log.level = DEBUG
    @tag = tag
    @buf = []
    
    @end_tag = "/#{tag}"
    @contents = ''
    @in_tag = false
    @end_tag_candidate = ''
    @complete = false
  end
  
  def accept(ch)
    @log.debug "got #{ch}"
    if !@complete
      case ch
        when '<' then @in_tag = true
        when '>'
          @in_tag = false
          @log.debug "expected end tag \"#{@end_tag}\", got \"#{@end_tag_candidate}\""
          if @end_tag_candidate == @end_tag
            @complete = true
            @contents = @buf.join
            @log.debug "***Element completed: #{self}"
          else
            @contents << "<#{@end_tag_candidate}>"
          end
        else 
          if !@in_tag
            @buf << ch
            @log.debug self
          else
            @end_tag_candidate << ch
            @log.debug "#{self}, end_tag_candidate => \"#{@end_tag_candidate}\""
          end
      end
    end
  end
  
  def to_s
    "Element: #{@tag} => \"#{@contents}\""
  end
end