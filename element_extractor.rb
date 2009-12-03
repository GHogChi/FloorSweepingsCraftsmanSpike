require 'stack'
require 'log4r'
require 'lib/loggable'
require 'element'

include Log4r

class ElementExtractor 
  include Loggable
  
  def initialize
    @log = get_filelogger('logs')
    @log.level = DEBUG
  end
     
  def find_elements_in_string_by_tag_name(string, tag_names)
    stream = string.split(//).map {|c| c[0].ord }
    find_elements_by_tag_name stream, tag_names
  end
     
  def find_elements_by_tag_name(cstream, tag_names)
    found_elements = []
    in_tag = false
    curr_tag = ''
    curr_elements = Stack.new
    cstream.each do |c|
      ch = c.chr
      @log.debug "#{ch}: in_tag: #{in_tag}, curr_tag: #{curr_tag}"
      curr_elements.each { |e| e.accept ch }
      puts ch
      case ch
        when '<' then in_tag = true
        when "\n" then next if in_tag
        when ' ' then next if in_tag
        when '>'
          if in_tag
            # at the end of a start tag that matches one of the arguments, a new element is pushed on the stack
            tag_names.each do 
              |tag_name| 
              if curr_tag == tag_name
                curr_elements.push(Element.new(curr_tag)) 
                @log.debug("New element started for tag: #{curr_tag}")
                break
              end
            end
            curr_tag = ''
            in_tag = false
            @log.debug "in_tag set to false"
          end
        else
          curr_tag << ch if in_tag
          check_complete curr_elements, found_elements
        end
    end
    check_complete curr_elements, found_elements
    found_elements
  end
  
  private
  def check_complete(curr_elements, found_elements)
    if curr_elements.poppable and curr_elements.poppable.complete
      el = curr_elements.pop
      @log.debug "element popped: #{el.tag} => #{el.contents}\n"
      found_elements << el
    end    
  end
end

