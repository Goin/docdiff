require 'rubyunit'
require 'docdiff'
require 'nkf'

class TestSplittableString < RUNIT::TestCase
  def setup
  end
  def test_to_char_en_ascii
    string   = "foo bar"
    string.extend DocDiff::SplittableString
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\n"
    expected = ['f','o','o',' ','b','a','r']
    assert_equal(expected, string.to_char)
  end
  def test_to_char_ja_eucjp
    string   = "�������ʥ�������"
    string.extend DocDiff::SplittableString
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['��','��','��','��','��','��','��','��']
    assert_equal(expected, string.to_char)
  end
  def test_to_char_ja_sjis
    string = NKF.nkf('-s', "�������ʥ�������")
    string.extend DocDiff::SplittableString
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\n"
    expected = ['��','��','��','��','��','��','��','��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_char)
  end
  def test_to_word_en_ascii
    string   = "foo bar"
    string.extend DocDiff::SplittableString
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\n"
    expected = ['foo',' bar']
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_eucjp
    string   = "�������ʥ�������"
    string.extend DocDiff::SplittableString
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['����','����','��������']
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_sjis
    string = NKF.nkf('-s', "�������ʥ�������")
    string.extend DocDiff::SplittableString
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\n"
    expected = ['����','����','��������'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_word)
  end

end
