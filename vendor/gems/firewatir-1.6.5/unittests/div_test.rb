# feature tests for Divs, Spans and P's
# revision: $Revision: 1.0 $

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_Divs < Test::Unit::TestCase

  
  def setup
    goto_page("div.html")
  end
  
  def test_divs
    assert_raises(UnknownObjectException) {browser.div(:id , "div77").click }
    assert_raises(UnknownObjectException) {browser.div(:title , "div77").click }
    
    assert(browser.text_field(:name, "text1").verify_contains("0") )  
    browser.div(:id , "div3").click
    assert(browser.text_field(:name, "text1").verify_contains("1") )  
    browser.div(:id , "div4").click
    assert(browser.text_field(:name, "text1").verify_contains("0") )  
  end
  
  tag_method :test_show_all_objects, :fails_on_ie
  def test_show_all_objects
    assert_equal(36, browser.show_all_objects.length)
    assert_equal(3,browser.div(:id,"text_fields1").show_all_objects.length)
   
    assert_equal(8,browser.text_fields.length)
    assert_equal(3,browser.div(:id,"text_fields1").text_fields.length)
  end
  
  def test_div_properties
    assert_raises(UnknownObjectException) {browser.div(:id , "div77").text }
    assert_raises(UnknownObjectException) {browser.div(:title , "div77").text }
    
    assert_equal("This div has an onClick that increments text1", browser.div(:id , "div3").text.strip )
    assert_equal("This text is in a div with an id of div1 and title of test1",browser.div(:title , "Test1").text.strip )
    
    assert_raises(UnknownObjectException) {browser.div(:id , "div77").class_name }
    assert_equal("blueText" ,   browser.div(:id , "div2").class_name )
    assert_equal("" ,   browser.div(:id , "div1").class_name )
    
    assert_raises(UnknownObjectException) {browser.div(:index , 44).class_name }
    assert_equal("div1" ,      browser.div(:index , 1).id )
    assert_equal("" ,          browser.div(:index , 1).class_name )
    assert_equal("blueText" ,  browser.div(:index , 2).class_name )
    assert_equal(""    ,       browser.div(:index , 2).value)
    assert_equal(false ,       browser.div(:index , 2).disabled)
    assert_equal(""    ,       browser.div(:index , 2).name)
    assert_equal("div2",       browser.div(:index , 2).id)
    #puts  browser.div(:id,"text_fields1").to_s
  end
  
  def test_div_iterator
    assert_equal( 7 , browser.divs.length)
    assert_equal( "div1" , browser.divs[1].id )
    
    index =1
    browser.divs.each do |s|
      # puts "each - div= " + s.to_s
      assert_equal(browser.div(:index, index ).name , s.name )
      assert_equal(browser.div(:index, index ).id , s.id )
      assert_equal(browser.div(:index, index ).class_name , s.class_name )
      index +=1
    end
    assert_equal(index-1, browser.divs.length)   # -1 as we add 1 at the end of the loop
  end
  
  def test_objects_in_div
    assert(browser.div(:id, 'buttons1').button(:index,1).exists? )
    assert_false(browser.div(:id, 'buttons1').button(:index,3).exists? )
    assert(browser.div(:id, 'buttons1').button(:name,'b1').exists? )
    browser.div(:id, 'buttons1').button(:name,'b1').click
    
    assert(browser.div(:id, 'buttons2').button(:index,1).exists? )
    assert(browser.div(:id, 'buttons2').button(:index,2).exists? )
    assert_false(browser.div(:id, 'buttons1').button(:index,3).exists? )
    
    browser.div(:id, 'buttons1').button(:index,1).click
    
    assert_equal( 'button1' ,   browser.div(:id , 'text_fields1').text_field(:index,1).value)
    
    #assert_equal( 3 , browser.div(:id , 'text_fields1').text_fields.length )
   browser.div(:id, 'text_fields1').text_field(:name, 'div_text1').set("drink me")
   assert_equal("drink me", browser.div(:id, 'text_fields1').text_field(:name, 'div_text1').value)
 end
  
  #---- Span Tests ---
  def test_spans
    assert_raises(UnknownObjectException) {browser.span(:id , "span77").click }
    assert_raises(UnknownObjectException) {browser.span(:title , "span77").click }
    
    assert(browser.text_field(:name, "text2").verify_contains("0") )  
    browser.span(:id , "span3").click
    assert(browser.text_field(:name, "text2").verify_contains("1") )  
    
    browser.span(:id , "span4").click
    assert(browser.text_field(:name, "text2").verify_contains("0") )  
    
    #puts browser.span(:id,"text_fields1").to_s
  end
  
  def test_span_properties
    assert_raises(UnknownObjectException) {browser.span(:id , "span77").text }
    assert_raises(UnknownObjectException) {browser.span(:title , "span77").text }
    
    assert_equal("This span has an onClick that increments text2" ,   browser.span(:id , "span3").text.strip )
    assert_equal("This text is in a span with an id of span1 and title of test2" ,   browser.span(:title , "Test2").text.strip )
    
    assert_raises(UnknownObjectException) {browser.span(:id , "span77").class_name }
    assert_equal("blueText" ,   browser.span(:id , "span2").class_name )
    assert_equal("" ,   browser.span(:id , "span1").class_name )
    
    assert_raises(UnknownObjectException) {browser.span(:index , 44).class_name }
    assert_equal("span1" ,     browser.span(:index , 1).id )
    assert_equal("" ,          browser.span(:index , 1).class_name )
    assert_equal("blueText" ,  browser.span(:index , 2).class_name )
    assert_equal(""    ,       browser.span(:index , 2).value)
    assert_equal(false ,       browser.span(:index , 2).disabled)
    assert_equal(""    ,       browser.span(:index , 2).name)
    assert_equal("span2",      browser.span(:index , 2).id)
  end
  
  def test_span_iterator
    assert_equal(7, browser.spans.length)
    assert_equal("span1", browser.spans[1].id)
    
    index = 1
    browser.spans.each do |s|
      # puts "each - span = " + s.to_s
      assert_equal(browser.span(:index, index ).name , s.name )
      assert_equal(browser.span(:index, index ).id , s.id )
      assert_equal(browser.span(:index, index ).class_name , s.class_name )
      index += 1
    end
    assert_equal(index - 1, browser.spans.length)   # -1 as we add 1 at the end of the loop
  end
  
  def test_objects_in_span
    assert(browser.span(:id, 'buttons1').button(:index,1).exists? )
    assert_false(browser.span(:id, 'buttons1').button(:index,3).exists? )
    assert(browser.span(:id, 'buttons1').button(:name,'b1').exists? )
    
    assert(browser.span(:id, 'buttons2').button(:index,1).exists? )
    assert(browser.span(:id, 'buttons2').button(:index,2).exists? )
    assert_false(browser.span(:id, 'buttons1').button(:index,3).exists? )
    
    browser.span(:id, 'buttons1').button(:index,1).click
    
    assert_equal( 'button1' ,   browser.span(:id , 'text_fields1').text_field(:index,1).value)
    browser.span(:id , 'text_fields1').text_field(:index,1).set('text box inside span')
    assert_equal( 'text box inside span' ,   browser.span(:id , 'text_fields1').text_field(:index,1).value)
   
    #assert_equal( 3 , browser.span(:id , 'text_fields1').text_fields.length )
  end
  
  def test_p
    assert(browser.p(:id, 'number1').exists?)
    assert(browser.p(:index, 3).exists?)
    assert(browser.p(:title, 'test_3').exists?)
    
    assert_false(browser.p(:id, 'missing').exists?)
    assert_false(browser.p(:index, 8).exists?)
    assert_false(browser.p(:title, 'test_55').exists?)
    
    assert_raises( UnknownObjectException) {browser.p(:id , 'missing').class_name }
    assert_raises( UnknownObjectException) {browser.p(:id , 'missing').text }
    assert_raises( UnknownObjectException) {browser.p(:id , 'missing').title }
    assert_raises( UnknownObjectException) {browser.p(:id , 'missing').to_s }
    assert_raises( UnknownObjectException) {browser.p(:id , 'missing').disabled }
    
    assert_equal(  'redText' , browser.p(:index,1).class_name)
    assert_equal(  'P_tag_1' , browser.p(:index,1).title)
    assert_equal(  'This text is in a p with an id of number2' , browser.p(:index,2).text)
  end
  
  def test_p_iterator
    assert_equal( 3, browser.ps.length)
    assert_equal( 'italicText', browser.ps[2].class_name)
    assert_equal( 'number3', browser.ps[3].id)
    
    count=1
    browser.ps.each do |p|
      assert_equal('number'+count.to_s , p.id)
      count+=1
    end
    assert_equal( count-1 ,  browser.ps.length)
  end
end

class TC_Divs_Display < Test::Unit::TestCase
  
  include CaptureIOHelper

  tag_method :test_showDivs, :fails_on_ie
  def test_showDivs
    goto_page("div.html")
    actual = capture_stdout { browser.showDivs }
    
    assert_equal(<<END_OF_MESSAGE, actual)
There are 7 divs
div:   name: 
         id: div1
      class: 
      index: 1
div:   name: 
         id: div2
      class: blueText
      index: 2
div:   name: 
         id: div3
      class: 
      index: 3
div:   name: 
         id: div4
      class: 
      index: 4
div:   name: 
         id: buttons1
      class: 
      index: 5
div:   name: 
         id: buttons2
      class: 
      index: 6
div:   name: divName
         id: text_fields1
      class: divClass
      index: 7
END_OF_MESSAGE
  end
end

class TC_Spans_Display < Test::Unit::TestCase
  include CaptureIOHelper

  tag_method :test_showSpans, :fails_on_ie
  def test_showSpans
    goto_page("div.html")
    actual = capture_stdout { browser.showSpans }
    assert_equal(<<END_OF_MESSAGE, actual)
There are 7 spans
span:  name: 
         id: span1
      class: 
      index: 1
span:  name: 
         id: span2
      class: blueText
      index: 2
span:  name: 
         id: span3
      class: 
      index: 3
span:  name: 
         id: span4
      class: 
      index: 4
span:  name: 
         id: buttons1
      class: 
      index: 5
span:  name: 
         id: buttons2
      class: 
      index: 6
span:  name: spanName
         id: text_fields1
      class: spanClass
      index: 7
END_OF_MESSAGE
  end
end
