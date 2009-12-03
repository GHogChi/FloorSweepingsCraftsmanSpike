require 'element_extractor'
require 'element'
require 'lib/fake_char_stream'

describe ElementExtractor do

  before(:each) do
    @ex = ElementExtractor.new  
  end
  
  it "should return empty list when no elements found for tag name" do
    mockCS = FakeCharacterStream.new('not the woids yer lookin for')
    @ex.find_elements_by_tag_name(mockCS, 'tag').should eql []
  end
  
  it "should find elements by tagname" do
    mockCS = FakeCharacterStream.new('<tag>A</tag> asdasf <tag>B</tag>')
    found_elements = @ex.find_elements_by_tag_name(mockCS, ['tag'])
    found_elements.size.should eql 2
    element = found_elements[0]
    element.tag.should eql 'tag'
    element.contents.should eql 'A'
    
    element = found_elements[1]
    element.tag.should eql 'tag'
    element.contents.should eql 'B'
  end
  
  it "should find elements by multiple tag names" do
    mockCS = FakeCharacterStream.new('<tag1>ABC</tag1> asdasf <tag2>DEF</tag2>')
    found_elements = @ex.find_elements_by_tag_name(mockCS, ['tag1', 'tag2'])
    found_elements.size.should eql 2
    element = found_elements[0]
    element.tag.should eql 'tag1'
    element.contents.should eql 'ABC'
    
    element = found_elements[1]
    element.tag.should eql 'tag2'
    element.contents.should eql 'DEF'
  end    
  
  it "should find elements in a string" do
    found_elements = @ex.find_elements_in_string_by_tag_name('<i>XYZ</i>', ['i'])
    element = found_elements[0]
    element.tag.should eql 'i'
    element.contents.should eql 'XYZ'
  end
  
end