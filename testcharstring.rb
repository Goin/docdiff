#!/usr/bin/ruby
require 'test/unit'
require 'charstring'
require 'nkf'
require 'uconv'

class TC_CharString < Test::Unit::TestCase

  def setup()
    #
  end

  # test codeset module registration
  def test_codeset_ascii()
    str = "foo".extend CharString
    str.codeset = "ASCII"
    expected = CharString::ASCII
    assert_equal(expected, CharString::CodeSets[str.codeset])
  end
  def test_codeset_eucjp()
    str = "foo".extend CharString
    str.codeset = "EUC-JP"
    expected = CharString::EUC_JP
    assert_equal(expected, CharString::CodeSets[str.codeset])
  end
  def test_codeset_sjis()
    str = "foo".extend CharString
    str.codeset = "Shift_JIS"
    expected = CharString::Shift_JIS
    assert_equal(expected, CharString::CodeSets[str.codeset])
  end
  def test_codeset_utf8()
    str = "foo".extend CharString
    str.codeset = "UTF-8"
    expected = CharString::UTF8
    assert_equal(expected, CharString::CodeSets[str.codeset])
  end

  # test eol module registration
  def test_eol_cr()
    str = "foo".extend CharString
    str.eol = "CR"
    expected = CharString::CR
    assert_equal(expected, CharString::EOLChars[str.eol])
  end
  def test_eol_lf()
    str = "foo".extend CharString
    str.eol = "LF"
    expected = CharString::LF
    assert_equal(expected, CharString::EOLChars[str.eol])
  end
  def test_eol_crlf()
    str = "foo".extend CharString
    str.eol = "CRLF"
    expected = CharString::CRLF
    assert_equal(expected, CharString::EOLChars[str.eol])
  end

  # test eol eol_char method
  def test_eol_char_cr()
    str = "foo\rbar\r".extend CharString
    expected = "\r"
    assert_equal(expected, str.eol_char)
  end
  def test_eol_char_lf()
    str = "foo\nbar\n".extend CharString
    expected = "\n"
    assert_equal(expected, str.eol_char)
  end
  def test_eol_char_crlf()
    str = "foo\r\nbar\r\n".extend CharString
    expected = "\r\n"
    assert_equal(expected, str.eol_char)
  end
  def test_eol_char_none()
    str = "foobar".extend CharString
    expected = nil
    assert_equal(expected, str.eol_char)
  end
  def test_eol_char_none_for_0length_string()
    str = "".extend CharString
    expected = nil
    assert_equal(expected, str.eol_char)
  end
  def test_eol_char_none_eucjp()
    str = NKF.nkf("-e", "���ܸ�a b")
    str.extend CharString
    expected = nil
    assert_equal(expected, str.eol_char)
  end
  def test_eol_char_none_sjis()
    str = NKF.nkf("-s", "���ܸ�a b")
    str.extend CharString
    expected = nil
    assert_equal(expected, str.eol_char)
  end

  # test eol split_to_line() method
  def test_cr_split_to_line()
    str = "foo\rbar\r".extend CharString
    str.codeset = "ASCII"
    str.eol = "CR"
    expected = ["foo\r", "bar\r"]
    assert_equal(expected, str.split_to_line)
  end
  def test_cr_split_to_line_chomped_lastline()
    str = "foo\rbar".extend CharString
    str.codeset = "ASCII"
    str.eol = "CR"
    expected = ["foo\r", "bar"]
    assert_equal(expected, str.split_to_line)
  end
  def test_cr_split_to_line_empty_line()
    str = "foo\r\rbar\r".extend CharString
    str.codeset = "ASCII"
    str.eol = "CR"
    expected = ["foo\r", "\r", "bar\r"]
    assert_equal(expected, str.split_to_line)
  end
  def test_lf_split_to_line()
    str = "foo\nbar\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "LF"
    expected = ["foo\n", "bar\n"]
    assert_equal(expected, str.split_to_line)
  end
  def test_lf_split_to_line_chomped_lastline()
    str = "foo\nbar".extend CharString
    str.codeset = "ASCII"
    str.eol = "LF"
    expected = ["foo\n", "bar"]
    assert_equal(expected, str.split_to_line)
  end
  def test_lf_split_to_line_empty_line()
    str = "foo\n\nbar\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "LF"
    expected = ["foo\n", "\n", "bar\n"]
    assert_equal(expected, str.split_to_line)
  end
  def test_crlf_split_to_line()
    str = "foo\r\nbar\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = ["foo\r\n", "bar\r\n"]
    assert_equal(expected, str.split_to_line)
  end
  def test_crlf_split_to_line_chomped_lastline()
    str = "foo\r\nbar".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = ["foo\r\n", "bar"]
    assert_equal(expected, str.split_to_line)
  end
  def test_crlf_split_to_line_empty_line()
    str = "foo\r\n\r\nbar\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = ["foo\r\n", "\r\n", "bar\r\n"]
    assert_equal(expected, str.split_to_line)
  end

  # test ASCII module
  def test_ascii_split_to_word()
    str = "foo bar".extend CharString
    str.codeset = "ASCII"
    expected = ["foo ", "bar"]
    assert_equal(expected, str.split_to_word)
  end
  def test_ascii_split_to_word_withsymbol()
    str = "foo (bar) baz-baz".extend CharString
    str.codeset = "ASCII"
    expected = ["foo ", "(bar) ", "baz-baz"]
    assert_equal(expected, str.split_to_word)
  end
  def test_ascii_split_to_word_withquote()
    str = "foo's 'foo' \"bar\" 'baz.'".extend CharString
    str.codeset = "ASCII"
    expected = ["foo's ", "'foo' ", "\"bar\" ", "'baz.'"]
    assert_equal(expected, str.split_to_word)
  end
  def test_ascii_split_to_word_withlongspace()
    str = " foo  bar".extend CharString
    str.codeset = "ASCII"
    expected = [" ", "foo ", " ", "bar"]
    assert_equal(expected, str.split_to_word)
  end
  def test_ascii_split_to_word_withdash()
    str = "foo -- bar, baz - quux".extend CharString
    str.codeset = "ASCII"
    expected = ["foo ", "-- ", "bar, ", "baz ", "- ", "quux"]
    assert_equal(expected, str.split_to_word)
  end
  def test_ascii_split_to_char()
    str = "foo bar".extend CharString
    str.codeset = "ASCII"
    str.eol = "LF"
    expected = ["f","o","o"," ","b","a","r"]
    assert_equal(expected, str.split_to_char)
  end
  def test_ascii_split_to_char_with_eol_cr()
    str = "foo bar\r".extend CharString
    str.codeset = "ASCII"
    str.eol = "CR"
    expected = ["f","o","o"," ","b","a","r","\r"]
    assert_equal(expected, str.split_to_char)
  end
  def test_ascii_split_to_char_with_eol_lf()
    str = "foo bar\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "LF"
    expected = ["f","o","o"," ","b","a","r","\n"]
    assert_equal(expected, str.split_to_char)
  end
  def test_ascii_split_to_char_with_eol_crlf()
    str = "foo bar\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = ["f","o","o"," ","b","a","r","\r\n"]
    assert_equal(expected, str.split_to_char)
  end
  def test_ascii_split_to_byte()
    str = "foo bar\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = ["f","o","o"," ","b","a","r","\r","\n"]
    assert_equal(expected, str.split_to_byte)
  end
  def test_ascii_count_byte()
    str = "foo bar\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 9
    assert_equal(expected, str.count_byte)
  end
  def test_ascii_count_char()
    str = "foo bar\r\nbaz quux\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 17
    assert_equal(expected, str.count_char)
  end
  def test_ascii_count_latin_graph_char()
    str = "foo bar\r\nbaz quux\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 13
    assert_equal(expected, str.count_latin_graph_char)
  end
  def test_ascii_count_graph_char()
    str = "foo bar\r\nbaz quux\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 13
    assert_equal(expected, str.count_graph_char)
  end
  def test_ascii_count_latin_blank_char()
    str = "foo bar\r\nbaz\tquux\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 2
    assert_equal(expected, str.count_latin_blank_char)
  end
  def test_ascii_count_blank_char()
    str = "foo bar\r\nbaz\tquux\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 2
    assert_equal(expected, str.count_blank_char)
  end
  def test_ascii_count_word()
    str = "foo bar   \r\nbaz quux\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 6
    assert_equal(expected, str.count_word)
  end
  def test_ascii_count_latin_word()
    str = "foo bar   \r\nbaz quux\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 5  # "  " is also counted as a word
    assert_equal(expected, str.count_latin_word)
  end
  def test_ascii_count_latin_valid_word()
    str = "1 foo   \r\n%%% ()\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 2
    assert_equal(expected, str.count_latin_valid_word)
  end
  def test_ascii_count_line()
    str = "foo\r\nbar".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 2
    assert_equal(expected, str.count_line)
  end
  def test_ascii_count_graph_line()
    str = "foo\r\n ".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 1
    assert_equal(expected, str.count_graph_line)
  end
  def test_ascii_count_empty_line()
    str = "foo\r\n \r\n\t\r\n\r\n".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 1
    assert_equal(expected, str.count_empty_line)
  end
  def test_ascii_count_blank_line()
    str = "\r\n \r\n\t\r\n ".extend CharString
    str.codeset = "ASCII"
    str.eol = "CRLF"
    expected = 3
    assert_equal(expected, str.count_blank_line)
  end

  # test EUCJP module
  def test_eucjp_split_to_word()
    str = NKF.nkf("-e", "���ܸ��ʸ��foo bar")
    str.extend CharString
#    str.codeset = "EUC-JP"
    expected = ["���ܸ��","ʸ��","foo ","bar"].collect{|c| NKF.nkf("-e", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_eucjp_split_to_word_kanhira()
    str = NKF.nkf("-e", "���ܸ��ʸ��")
    str.extend CharString
#    str.codeset = "EUC-JP"
    expected = ["���ܸ��", "ʸ��"].collect{|c| NKF.nkf("-e", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_eucjp_split_to_word_katahira()
    str = NKF.nkf("-e", "�������ʤ�ʸ��")
    str.extend CharString
#    str.codeset = "EUC-JP"
    expected = ["�������ʤ�", "ʸ��"].collect{|c| NKF.nkf("-e", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_eucjp_split_to_word_kataonbiki()
    str = NKF.nkf("-e", "��ӡ�������")
    str.extend CharString
    str.codeset = "EUC-JP" #<= needed to pass the test
    expected = ["��ӡ�", "����", "��"].collect{|c| NKF.nkf("-e", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_eucjp_split_to_word_hiraonbiki()
    str = NKF.nkf("-e", "���ӡ���")
    str.extend CharString
    str.codeset = "EUC-JP" #<= needed to pass the test
    expected = ["�", "��ӡ���"].collect{|c| NKF.nkf("-e", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_eucjp_split_to_word_latinmix()
    str = NKF.nkf("-e", "���ܸ��Latin��ʸ��")
    str.extend CharString
#    str.codeset = "EUC-JP"
    expected = ["���ܸ��", "Latin", "��", "ʸ��"].collect{|c| NKF.nkf("-e", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_eucjp_split_to_char()
    str = NKF.nkf("-e", "���ܸ�a b")
    str.extend CharString
    str.eol = "LF" #<= needed to pass the test
#    str.codeset = "EUC-JP"
    expected = ["��","��","��","a"," ","b"].collect{|c|NKF.nkf("-e",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_eucjp_split_to_char_with_cr()
    str = NKF.nkf("-e", "���ܸ�a b\r")
    str.extend CharString
#    str.eol = "CR"
#    str.codeset = "EUC-JP"
    expected = ["��","��","��","a"," ","b","\r"].collect{|c|NKF.nkf("-e",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_eucjp_split_to_char_with_lf()
    str = NKF.nkf("-e", "���ܸ�a b\n")
    str.extend CharString
#     str.eol = "LF"
#     str.codeset = "EUC-JP"
    expected = ["��","��","��","a"," ","b","\n"].collect{|c|NKF.nkf("-e",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_eucjp_split_to_char_with_crlf()
    str = NKF.nkf("-e", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = ["��","��","��","a"," ","b","\r\n"].collect{|c|NKF.nkf("-e",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_eucjp_count_char()
    str = NKF.nkf("-e", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 7
    assert_equal(expected, str.count_char)
  end
  def test_eucjp_count_latin_graph_char()
    str = NKF.nkf("-e", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 2
    assert_equal(expected, str.count_latin_graph_char)
  end
  def test_eucjp_count_ja_graph_char()
    str = NKF.nkf("-e", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 3
    assert_equal(expected, str.count_ja_graph_char)
  end
  def test_eucjp_count_graph_char()
    str = NKF.nkf("-e", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 5
    assert_equal(expected, str.count_graph_char)
  end
  def test_eucjp_count_latin_blank_char()
    str = NKF.nkf("-e", "���ܸ�\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 2
    assert_equal(expected, str.count_latin_blank_char)
  end
  def test_eucjp_count_ja_blank_char()
    str = NKF.nkf("-e", "���ܡ���\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 1
    assert_equal(expected, str.count_ja_blank_char)
  end
  def test_eucjp_count_blank_char()
    str = NKF.nkf("-e", "���ܡ���\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 3
    assert_equal(expected, str.count_blank_char)
  end
  def test_eucjp_count_word()
    str = NKF.nkf("-e", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 7 # "--" and "\r\n" are counted as word here (though not "valid")
    assert_equal(expected, str.count_word)
  end
  def test_eucjp_count_ja_word()
    str = NKF.nkf("-e", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 3
    assert_equal(expected, str.count_ja_word)
  end
  def test_eucjp_count_latin_valid_word()
    str = NKF.nkf("-e", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 2
    assert_equal(expected, str.count_latin_valid_word)
  end
  def test_eucjp_count_ja_valid_word()
    str = NKF.nkf("-e", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 2
    assert_equal(expected, str.count_ja_valid_word)
  end
  def test_eucjp_count_valid_word()
    str = NKF.nkf("-e", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "EUC-JP"
    expected = 4
    assert_equal(expected, str.count_valid_word)
  end
  def test_eucjp_count_line()
    str = NKF.nkf("-e", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "EUC-JP"
#     str.eol = "CRLF"
    expected = 6
    assert_equal(expected, str.count_line)
  end
  def test_eucjp_count_graph_line()
    str = NKF.nkf("-e", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "EUC-JP"
#     str.eol = "CRLF"
    expected = 3
    assert_equal(expected, str.count_graph_line)
  end
  def test_eucjp_count_empty_line()
    str = NKF.nkf("-e", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "EUC-JP"
#     str.eol = "CRLF"
    expected = 1
    assert_equal(expected, str.count_empty_line)
  end
  def test_eucjp_count_blank_line()
    str = NKF.nkf("-e", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "EUC-JP"
#     str.eol = "CRLF"
    expected = 2
    assert_equal(expected, str.count_blank_line)
  end

  # test SJIS module
  def test_sjis_split_to_word()
    str = NKF.nkf("-s", "���ܸ��ʸ��foo bar")
    str.extend CharString
#     str.codeset = "Shift_JIS"
    expected = ["���ܸ��", "ʸ��", "foo ", "bar"].collect{|c|NKF.nkf("-s",c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_sjisplit_s_to_word_kanhira()
    str = NKF.nkf("-s", "���ܸ��ʸ��")
    str.extend CharString
#     str.codeset = "Shift_JIS"
    expected = ["���ܸ��", "ʸ��"].collect{|c| NKF.nkf("-s", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_sjis_split_to_word_katahira()
    str = NKF.nkf("-s", "�������ʤ�ʸ��")
    str.extend CharString
#     str.codeset = "Shift_JIS"
    expected = ["�������ʤ�", "ʸ��"].collect{|c| NKF.nkf("-s", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_sjis_split_to_word_kataonbiki()
    str = NKF.nkf("-s", "��ӡ��λ���")
    str.extend CharString
#     str.codeset = "Shift_JIS"
    expected = ["��ӡ���", "����"].collect{|c| NKF.nkf("-s", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_sjis_split_to_word_hiraonbiki()
    str = NKF.nkf("-s", "���ӡ���")
    str.extend CharString
#     str.codeset = "Shift_JIS"
    expected = ["�", "��ӡ���"].collect{|c| NKF.nkf("-s", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_sjis_split_to_word_latinmix()
    str = NKF.nkf("-s", "���ܸ��Latin��ʸ��")
    str.extend CharString
#     str.codeset = "Shift_JIS"
    expected = ["���ܸ��","Latin","��","ʸ��"].collect{|c| NKF.nkf("-s", c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_sjis_split_to_char()
    str = NKF.nkf("-s", "ɽ�׻�a b")
    str.extend CharString
#     str.codeset = "Shift_JIS"
    str.eol = "LF" #<= needed to pass the test
    expected = ["ɽ","��","��","a"," ","b"].collect{|c|NKF.nkf("-s",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_sjis_split_to_char_with_cr()
    str = NKF.nkf("-s", "ɽ�׻�a b\r")
    str.extend CharString
#     str.codeset = "Shift_JIS"
#     str.eol = "CR"
    expected = ["ɽ","��","��","a"," ","b","\r"].collect{|c|NKF.nkf("-s",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_sjis_split_to_char_with_lf()
    str = NKF.nkf("-s", "ɽ�׻�a b\n")
    str.extend CharString
#     str.codeset = "Shift_JIS"
#     str.eol = "LF"
    expected = ["ɽ","��","��","a"," ","b","\n"].collect{|c|NKF.nkf("-s",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_sjis_split_to_char_with_crlf()
    str = NKF.nkf("-s", "ɽ�׻�a b\r\n")
    str.extend CharString
#     str.codeset = "Shift_JIS"
#     str.eol = "CRLF"
    expected = ["ɽ","��","��","a"," ","b","\r\n"].collect{|c|NKF.nkf("-s",c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_sjis_count_char()
    str = NKF.nkf("-s", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 7
    assert_equal(expected, str.count_char)
  end
  def test_sjis_count_latin_graph_char()
    str = NKF.nkf("-s", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 2
    assert_equal(expected, str.count_latin_graph_char)
  end
  def test_sjis_count_ja_graph_char()
    str = NKF.nkf("-s", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 3
    assert_equal(expected, str.count_ja_graph_char)
  end
  def test_sjis_count_graph_char()
    str = NKF.nkf("-s", "���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 5
    assert_equal(expected, str.count_graph_char)
  end
  def test_sjis_count_latin_blank_char()
    str = NKF.nkf("-s", "���ܸ�\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 2
    assert_equal(expected, str.count_latin_blank_char)
  end
  def test_sjis_count_ja_blank_char()
    str = NKF.nkf("-s", "���ܡ���\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 1
    assert_equal(expected, str.count_ja_blank_char)
  end
  def test_sjis_count_blank_char()
    str = NKF.nkf("-s", "���ܡ���\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 3
    assert_equal(expected, str.count_blank_char)
  end
  def test_sjis_count_word()
    str = NKF.nkf("-s", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 7 # "--" and "\r\n" are counted as word here (though not "valid")
    assert_equal(expected, str.count_word)
  end
  def test_sjis_count_ja_word()
    str = NKF.nkf("-s", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 3
    assert_equal(expected, str.count_ja_word)
  end
  def test_sjis_count_latin_valid_word()
    str = NKF.nkf("-s", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 2
    assert_equal(expected, str.count_latin_valid_word)
  end
  def test_sjis_count_ja_valid_word()
    str = NKF.nkf("-s", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 2
    assert_equal(expected, str.count_ja_valid_word)
  end
  def test_sjis_count_valid_word()
    str = NKF.nkf("-s", "���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "Shift_JIS"
    expected = 4
    assert_equal(expected, str.count_valid_word)
  end
  def test_sjis_count_line()
    str = NKF.nkf("-s", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "Shift_JIS"
#     str.eol = "CRLF"
    expected = 6
    assert_equal(expected, str.count_line)
  end
  def test_sjis_count_graph_line()
    str = NKF.nkf("-s", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "Shift_JIS"
#     str.eol = "CRLF"
    expected = 3
    assert_equal(expected, str.count_graph_line)
  end
  def test_sjis_count_empty_line()
    str = NKF.nkf("-s", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "Shift_JIS"
#     str.eol = "CRLF"
    expected = 1
    assert_equal(expected, str.count_empty_line)
  end
  def test_sjis_count_blank_line()
    str = NKF.nkf("-s", "���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "Shift_JIS"
#     str.eol = "CRLF"
    expected = 2
    assert_equal(expected, str.count_blank_line)
  end

  # test UTF8 module
  def test_utf8_split_to_word()
    str = Uconv.euctou8("���ܸ��ʸ��foo bar")
    str.extend CharString
#     str.codeset = "UTF-8"
    expected = ["���ܸ��", "ʸ��", "foo ", "bar"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_utf8_split_to_word_kanhira()
    str = Uconv.euctou8("���ܸ��ʸ��")
    str.extend CharString
#     str.codeset = "UTF-8"
    expected = ["���ܸ��", "ʸ��"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_utf8_split_to_word_katahira()
    str = Uconv.euctou8("�������ʤ�ʸ��")
    str.extend CharString
#     str.codeset = "UTF-8"
    expected = ["�������ʤ�", "ʸ��"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_utf8_split_to_word_kataonbiki()
    str = Uconv.euctou8("��ӡ��λ���")
    str.extend CharString
#     str.codeset = "UTF-8"
    expected = ["��ӡ���", "����"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_utf8_split_to_word_hiraonbiki()
    str = Uconv.euctou8("���ӡ���")
    str.extend CharString
#     str.codeset = "UTF-8"
    expected = ["�", "��ӡ���"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_utf8_split_to_word_latinmix()
    str = Uconv.euctou8("���ܸ��Latin��ʸ��")
    str.extend CharString
#     str.codeset = "UTF-8"
    expected = ["���ܸ��", "Latin", "��", "ʸ��"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_word)
  end
  def test_utf8_split_to_char()
    str = Uconv.euctou8("���ܸ�a b")
    str.extend CharString
    str.codeset = "UTF-8" #<= needed to pass the test
    str.eol = "LF"        #<= needed to pass the test
    expected = ["��", "��", "��", "a", " ", "b"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_utf8_split_to_char_with_cr()
    str = Uconv.euctou8("���ܸ�a b\r")
    str.extend CharString
    str.codeset = "UTF-8" #<= needed to pass the test
#     str.eol = "CR"
    expected = ["��","��","��","a"," ","b","\r"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_utf8_split_to_char_with_lf()
    str = Uconv.euctou8("���ܸ�a b\n")
    str.extend CharString
    str.codeset = "UTF-8" #<= needed to pass the test
#     str.eol = "LF"
    expected = ["��","��","��","a"," ","b","\n"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_utf8_split_to_char_with_crlf()
    str = Uconv.euctou8("���ܸ�a b\r\n")
    str.extend CharString
    str.codeset = "UTF-8"#<= needed to pass the test
#     str.eol = "CRLF"
    expected = ["��","��","��","a"," ","b","\r\n"].collect{|c| Uconv.euctou8(c)}
    assert_equal(expected, str.split_to_char)
  end
  def test_utf8_count_char()
    str = Uconv.euctou8("���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
    str.codeset = "UTF-8" #<= needed to pass the test
    expected = 7
    assert_equal(expected, str.count_char)
  end
  def test_utf8_count_latin_graph_char()
    str = Uconv.euctou8("���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
    str.codeset = "UTF-8" #<= needed to pass the test
    expected = 2
    assert_equal(expected, str.count_latin_graph_char)
  end
  def test_utf8_count_ja_graph_char()
    str = Uconv.euctou8("���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
    str.codeset = "UTF-8" #<= needed to pass the test
    expected = 3
    assert_equal(expected, str.count_ja_graph_char)
  end
  def test_utf8_count_graph_char()
    str = Uconv.euctou8("���ܸ�a b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
    str.codeset = "UTF-8" #<= needed to passs the test
    expected = 5
    assert_equal(expected, str.count_graph_char)
  end
  def test_utf8_count_latin_blank_char()
    str = Uconv.euctou8("���ܸ�\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 2
    assert_equal(expected, str.count_latin_blank_char)
  end
  def test_utf8_count_ja_blank_char()
    str = Uconv.euctou8("���ܡ���\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 1
    assert_equal(expected, str.count_ja_blank_char)
  end
  def test_utf8_count_blank_char()
    str = Uconv.euctou8("���ܡ���\ta b\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 3
    assert_equal(expected, str.count_blank_char)
  end
  def test_utf8_count_word()
    str = Uconv.euctou8("���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 7 # "--" and "\r\n" are counted as word here (though not "valid")
    assert_equal(expected, str.count_word)
  end
  def test_utf8_count_ja_word()
    str = Uconv.euctou8("���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 3
    assert_equal(expected, str.count_ja_word)
  end
  def test_utf8_count_latin_valid_word()
    str = Uconv.euctou8("���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 2
    assert_equal(expected, str.count_latin_valid_word)
  end
  def test_utf8_count_ja_valid_word()
    str = Uconv.euctou8("���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 2
    assert_equal(expected, str.count_ja_valid_word)
  end
  def test_utf8_count_valid_word()
    str = Uconv.euctou8("���ܡ���a b --\r\n")
    str.extend CharString
#     str.eol = "CRLF"
#     str.codeset = "UTF-8"
    expected = 4
    assert_equal(expected, str.count_valid_word)
  end
  def test_utf8_count_line()
    str = Uconv.euctou8("���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "UTF-8"
#     str.eol = "CRLF"
    expected = 6
    assert_equal(expected, str.count_line)
  end
  def test_utf8_count_graph_line()
    str = Uconv.euctou8("���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "UTF-8"
#     str.eol = "CRLF"
    expected = 3
    assert_equal(expected, str.count_graph_line)
  end
  def test_utf8_count_empty_line()
    str = Uconv.euctou8("���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "UTF-8"
#     str.eol = "CRLF"
    expected = 1
    assert_equal(expected, str.count_empty_line)
  end
  def test_utf8_count_blank_line()
    str = Uconv.euctou8("���ܸ�\r\n��\r\n \r\n\r\nfoo\r\nbar")
    str.extend CharString
#     str.codeset = "UTF-8"
#     str.eol = "CRLF"
    expected = 2
    assert_equal(expected, str.count_blank_line)
  end

  # test module functions
  def test_guess_codeset_ascii()
    str = "ASCII string"
    expected = "ASCII"
    assert_equal(expected, CharString.guess_codeset(str))
  end
  def test_guess_codeset_eucjp()
    str = NKF.nkf("-e", "���ܸ��Latin��ʸ��")
    expected = "EUC-JP"
    assert_equal(expected, CharString.guess_codeset(str))
  end
  def test_guess_codeset_jis()
    str = NKF.nkf("-j", "���ܸ��Latin��ʸ��")
    expected = "JIS"
    assert_equal(expected, CharString.guess_codeset(str))
  end
  def test_guess_codeset_sjis()
    str = NKF.nkf("-s", "���ܸ��Latin��ʸ��")
    expected = "Shift_JIS"
    assert_equal(expected, CharString.guess_codeset(str))
  end
  def test_guess_codeset_utf8()
    str = Uconv.euctou8("���ܸ��Latin��ʸ��")
    expected = "UTF-8"
    assert_equal(expected, CharString.guess_codeset(str))
  end
  def test_guess_codeset_nil()
    str = nil
    expected = nil
    assert_equal(expected, CharString.guess_codeset(str))
  end
#   def test_guess_codeset_binary()
#     str = "\xFF\xFF"
#     expected = "BINARY"
#     assert_equal(expected, CharString.guess_codeset(str))
#   end
  def test_guess_codeset_unknown()
    str = "\xff\xff\xff\xff"  # "\xDE\xAD\xBE\xEF"
    expected = "UNKNOWN"
    assert_equal(expected, CharString.guess_codeset(str))
  end
  def test_guess_codeset_auto_ascii()
    str = "abc\ndef\n".extend CharString
    expected = "ASCII"
    assert_equal(expected, str.codeset)
  end
  def test_guess_codeset_auto_eucjp()
    str = NKF.nkf('-e', "�����ȥ������ʤȤҤ餬��\n")
    str.extend CharString
    expected = "EUC-JP"
    assert_equal(expected, str.codeset)
  end
  def test_guess_codeset_auto_sjis()
    str = NKF.nkf('-s', "�����\n�ˤۤؤ�\n")
    str.extend CharString
    expected = "Shift_JIS"
    assert_equal(expected, str.codeset)
  end
  def test_guess_codeset_auto_utf8()
    str = Uconv.euctou8("�����\n�ˤۤؤ�\n")
    str.extend CharString
    expected = "UTF-8"
    assert_equal(expected, str.codeset)
  end
  def test_guess_eol_nil()
    str = nil
    expected = nil
    assert_equal(expected, CharString.guess_eol(str))
  end
  def test_guess_eol_empty()
    str = ""
    expected = "NONE"
    assert_equal(expected, CharString.guess_eol(str))
  end
  def test_guess_eol_none()
    str = "foo bar"
    expected = "NONE"
    assert_equal(expected, CharString.guess_eol(str))
  end
  def test_guess_eol_cr()
    str = "foo bar\r"
    expected = "CR"
    assert_equal(expected, CharString.guess_eol(str))
  end
  def test_guess_eol_lf()
    str = "foo bar\n"
    expected = "LF"
    assert_equal(expected, CharString.guess_eol(str))
  end
  def test_guess_eol_crlf()
    str = "foo bar\r\n"
    expected = "CRLF"
    assert_equal(expected, CharString.guess_eol(str))
  end
  def test_guess_eol_mixed()
    str = "foo\rbar\nbaz\r\n"
    expected = "UNKNOWN"
    assert_equal(expected, CharString.guess_eol(str))
  end
  def test_guess_eol_auto_cr()
    str = "foo\rbar\rbaz\r"
    str.extend CharString
    expected = "CR"
    assert_equal(expected, str.eol)
  end
  def test_guess_eol_auto_lf()
    str = "foo\nbar\nbaz\n"
    str.extend CharString
    expected = "LF"
    assert_equal(expected, str.eol)
  end
  def test_guess_eol_auto_crlf()
    str = "foo\r\nbar\r\nbaz\r\n"
    str.extend CharString
    expected = "CRLF"
    assert_equal(expected, str.eol)
  end

  def teardown()
    #
  end

end
