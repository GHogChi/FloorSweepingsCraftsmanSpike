require 'stack'
require 'log4r'
include Log4r


class TagExtractor 
  
  def initialize
    o = StdoutOutputter.new 'console'
    #o.only_at ALL # DEBUG, FATAL         # only DEBUG and FATAL get written
    fname = 'TagExtractor.log'
    pf = PatternFormatter.new(:pattern => "[%l] %d :: %m")
    f = FileOutputter.new fname, {:filename => fname, :truncate => false, :formatter => pf}
    
    @log = Logger.new 'TagExtractorLog'
    @log.outputters = f
    @log.level = DEBUG
  end
    
  def find_all_tags(cstream)
    in_tag = false
    curr_tag = ''
    tags = []
    cstream.each do |c|
      ch = c.chr
      puts ch
      case ch
      when '<'
        in_tag = true
      when "\n" then next
      when ' ' then next
      when '>'
        if in_tag and curr_tag.size > 0
          tags << curr_tag
          curr_tag = ''
        end
        in_tag = false
      else
        curr_tag << c if in_tag
      end
    end
    tags
  end
  
  def find_elements_by_tag_name(cstream, tag_names)
    found_elements = []
    in_tag = false
    in_end_tag = false
    curr_tag = ''
    curr_elements = Stack.new
    cstream.each do |c|
      ch = c.chr
      puts ch
      case ch
      when '<' then in_tag = true
      when "\n" then next
      when ' ' then next
      when '>'
        # at the end of a start tag that matches one of the arguments, a new element is pushed on the stack
        curr_tag_match = false
        tag_names.each do 
          |tag_name| 
          if curr_tag == tag_name
            curr_tag_match = true
            @log.debug "curr_tag: #{curr_tag}"
            break
          end
        end
        new_element_starting = ((in_tag and !in_end_tag) and curr_tag.size > 0) and curr_tag_match
        #        print "in_tag: #{in_tag}, start_tag: #{start_tag}, curr_tag:\"#{curr_tag}\""
        if new_element_starting
          curr_elements.push(Element.new(curr_tag)) 
          @log.debug ("New element started for curr_tag: #{curr_tag}")
        elsif in_end_tag and curr_tag == curr_elements.look.tag
          el = curr_elements.pop
          @log.debug "element popped: #{el.tag} => #{el.contents}\n"
          found_elements << el
        end          
        curr_tag = ''
        in_tag = in_end_tag = false
      else
        if in_tag 
          if (ch == '/') and (curr_tag.size == 0 ) 
            in_end_tag = true
          else
            curr_tag << ch
          end
        end
#        puts "ch: '#{ch}', in_tag: #{in_tag}, curr_tag: '#{curr_tag}'"
#        puts "\t(in end tag: #{in_end_tag})"
        curr_elements.each { |e| e.accept ch }
      end
    end
    found_elements
  end
end

class Element
  
  attr_accessor :tag, :contents
  def initialize (tag)
    @tag = tag
    @contents = []
  end
  
  def accept(ch)
    @contents << ch
  end
end