#!/usr/bin/ruby
require 'test/unit'
require 'docdiff'
require 'nkf'
require 'uconv'

class TC_Document < Test::Unit::TestCase

  def setup()
    #
  end

  def test_compare_by_line()
    doc1 = Document.new("Foo bar.\nBaz quux.", 'ASCII', 'LF')
    doc2 = Document.new("Foo.\nBaz quux.", 'ASCII', 'LF')
    docdiff = DocDiff.new
    expected = [[:change_elt,     ["Foo bar.\n"], ["Foo.\n"]],
                [:common_elt_elt, ['Baz quux.'], ['Baz quux.']]]
    assert_equal(expected, docdiff.compare_by_line(doc1, doc2))
  end
  def test_compare_by_line_word()
    doc1 = Document.new("a b c d\ne f", 'ASCII', 'LF')
    doc2 = Document.new("a x c d\ne f", 'ASCII', 'LF')
    docdiff = DocDiff.new
    expected = [[:common_elt_elt, ["a "], ["a "]],
                [:change_elt,     ["b "], ["x "]],
                [:common_elt_elt, ["c ", "d", "\n"], ["c ", "d", "\n"]],
                [:common_elt_elt, ["e f"], ["e f"]]]
    assert_equal(expected,
                 docdiff.compare_by_line_word(doc1, doc2))
  end
  def test_compare_by_line_word_char()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    docdiff = DocDiff.new
    expected = [[:common_elt_elt, ['foo '], ['foo ']],
                [:common_elt_elt, ['b'], ['b']],
                [:change_elt,     ['a'], ['e', 'e']],
                [:common_elt_elt, ['r'], ['r']],
                [:common_elt_elt, ["\n"], ["\n"]],
                [:common_elt_elt, ['baz'], ['baz']]]
    assert_equal(expected,
                 docdiff.compare_by_line_word_char(doc1, doc2))
  end

  def test_run_line_xhtml()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    docdiff = DocDiff.new
    expected = '<?xml version="1.0" encoding="ASCII"?>' + "\n" +
     '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"' + "\n" +
     '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' + "\n" +
     '<html><head>' + "\n" +
     '<meta http-equiv="Content-Type" content="text/html; charset=ASCII" />' + "\n" +
     '<title>, </title>' + "\n" +
     '<style type="text/css">' + "\n" +
     'span.del {background: pink;}' + "\n" +
     'span.add {background: lightgreen; font-size: larger; font-weight: bolder;}' + "\n" +
     'span.before_change {background: pink;}' + "\n" +
     'span.after_change {background: lightgreen; font-size: larger; font-weight: bolder;}' + "\n" +
     '</style>' + "\n" +
     '</head><body>' + "\n" +
     '<span class="before_change"><del>foo&nbsp;bar<br />' + "\n" + '</del></span>' +
     '<span class="after_change"><ins>foo&nbsp;beer<br />' + "\n" + '</ins></span>' +
     '<span class="common">baz' + "</span>" + "\n</body></html>" + "\n"
    assert_equal(expected, docdiff.run(doc1, doc2, "line", "xhtml", digest = false))
  end

  def test_run_line_manued()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    docdiff = DocDiff.new
    expected = "defparentheses [ ]\n" +
               "defdelete      /\n" +
               "defswap        |\n" +
               "defcomment     ;\n" +
               "defescape      ~\n" +
               "deforder       newer-last\n" +
               "defversion     0.9.5\n" + 
               "[foo bar\n/foo beer\n]baz"
    assert_equal(expected, docdiff.run(doc1, doc2, "line", "manued", digest = false))
  end
  def test_run_word_manued()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    docdiff = DocDiff.new
    expected = "defparentheses [ ]\n" +
               "defdelete      /\n" +
               "defswap        |\n" +
               "defcomment     ;\n" +
               "defescape      ~\n" +
               "deforder       newer-last\n" +
               "defversion     0.9.5\n" + 
               "foo [bar/beer]\nbaz"
    assert_equal(expected, docdiff.run(doc1, doc2, "word", "manued", digest = false))
  end
  def test_run_char_manued()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    docdiff = DocDiff.new
    expected = "defparentheses [ ]\n" +
               "defdelete      /\n" +
               "defswap        |\n" +
               "defcomment     ;\n" +
               "defescape      ~\n" +
               "deforder       newer-last\n" +
               "defversion     0.9.5\n" + 
               "foo b[a/ee]r\nbaz"
    assert_equal(expected, docdiff.run(doc1, doc2, "char", "manued", digest = false))
  end

  def test_parse_config_file_content()
    content = ["# comment line\n",
               " # comment line with leading space\n",
               "foo1 = bar\n",
               "foo2 = bar baz \n",
               " foo3  =  123 # comment\n",
               "foo4 = no    \n",
               "foo1 = tRue\n",
               "\n",
               "",
               nil].to_s
    expected = {:foo1=>true, :foo2=>"bar baz", :foo3=>123, :foo4=>false}
    docdiff = DocDiff.new
    assert_equal(expected,
                 DocDiff.parse_config_file_content(content))
  end

  def test_run_line_user()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    config = {:tag_common_start          => '<=>',
              :tag_common_end            => '</=>',
              :tag_del_start             => '<->',
              :tag_del_end               => '</->',
              :tag_add_start             => '<+>',
              :tag_add_end               => '</+>',
              :tag_change_before_start   => '<!->',
              :tag_change_before_end     => '</!->',
              :tag_change_after_start    => '<!+>',
              :tag_change_after_end      => '</!+>'}
    docdiff = DocDiff.new
    docdiff.config.update(config)
    expected = "<!->foo bar\n</!-><!+>foo beer\n</!+><=>baz</=>"
    assert_equal(expected, docdiff.run(doc1, doc2, "line", "user", digest = false))
  end
  def test_run_word_user()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    config = {:tag_common_start          => '<=>',
              :tag_common_end            => '</=>',
              :tag_del_start             => '<->',
              :tag_del_end               => '</->',
              :tag_add_start             => '<+>',
              :tag_add_end               => '</+>',
              :tag_change_before_start   => '<!->',
              :tag_change_before_end     => '</!->',
              :tag_change_after_start    => '<!+>',
              :tag_change_after_end      => '</!+>'}
    docdiff = DocDiff.new
    docdiff.config.update(config)
    expected = "<=>foo </=><!->bar</!-><!+>beer</!+><=>\n</=><=>baz</=>"
    assert_equal(expected, docdiff.run(doc1, doc2, "word", "user", digest = false))
  end
  def test_run_char_user()
    doc1 = Document.new("foo bar\nbaz", 'ASCII', 'LF')
    doc2 = Document.new("foo beer\nbaz", 'ASCII', 'LF')
    config = {:tag_common_start          => '<=>',
              :tag_common_end            => '</=>',
              :tag_del_start             => '<->',
              :tag_del_end               => '</->',
              :tag_add_start             => '<+>',
              :tag_add_end               => '</+>',
              :tag_change_before_start   => '<!->',
              :tag_change_before_end     => '</!->',
              :tag_change_after_start    => '<!+>',
              :tag_change_after_end      => '</!+>'}
    docdiff = DocDiff.new
    docdiff.config.update(config)
    expected = "<=>foo </=><=>b</=><!->a</!-><!+>ee</!+><=>r</=><=>\n</=><=>baz</=>"
    assert_equal(expected, docdiff.run(doc1, doc2, "char", "user", digest = false))
  end


  def teardown()
    #
  end

end
