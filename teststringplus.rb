require 'rubyunit'
require 'docdiff'
require 'nkf'

class TestStringPlus < RUNIT::TestCase

  def setup()
    #@text_en = "Foo bar."
    #@text_ja_kanhira = 
  end

  # to_char tests.
  def test_to_char_en_ascii()
    string   = "foo bar"
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\n"
    expected = ['f','o','o',' ','b','a','r']
    assert_equal(expected, string.to_char)
  end
  def test_to_char_ja_eucjp()
    string   = "�������ʥ�������"
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['��','��','��','��','��','��','��','��']
    assert_equal(expected, string.to_char)
  end
  def test_to_char_ja_sjis()
    string = NKF.nkf('-s', "�������ʥ�������")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\n"
    expected = ['��','��','��','��','��','��','��','��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_char)
  end

#   def test_count_char_en_ascii_cr()
#   end
#   def test_count_char_en_ascii_lf()
#   end
#   def test_count_char_en_ascii_crlf()
#   end
##   def test_count_char_ja_eucjp_cr()
##   end
#   def test_count_char_ja_eucjp_lf()
#   end
##   def test_count_char_ja_eucjp_crlf()
##   end
#   def test_count_char_ja_sjis_cr()
#   end
##   def test_count_char_ja_sjis_lf()
##   end
#   def test_count_char_ja_sjis_crlf()
#   end

  # to_word tests.
  def test_to_word_en_ascii_lf()
    string   = "foo bar baz quux."
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\n"
    expected = ['foo ','bar ','baz ','quux','.']
    assert_equal(expected, string.to_word)
  end
  def test_to_word_en_ascii_lf_hyphen()
    string   = "Mr. Black, he\'s a high-school student."
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\n"
    expected = ["Mr. ","Black",", ","he\'s ","a ","high-school ","student","."]
    assert_equal(expected, string.to_word)
  end
  # EUC-JP encoding.  EoL is LF.
  def test_to_word_ja_eucjp_kanhira()
    string   = NKF.nkf('-e',"���٤��������ꤷ����")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['���٤���','������ꤷ��','��'].collect{|s|NKF.nkf('-e', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_eucjp_macronhira()
    string   = NKF.nkf('-e',"�롼���롣")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['�롼����','��'].collect{|s|NKF.nkf('-e', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_eucjp_macronkata_trail()
    string   = NKF.nkf('-e',"�ա������Υ�������")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['�ա�������','������','��'].collect{|s|NKF.nkf('-e', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_eucjp_macronkata_between()
    string   = NKF.nkf('-e',"�ǡ����򥽡��ȡ�")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['�ǡ�����','������','��'].collect{|s|NKF.nkf('-e', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_eucjp_repeatkan()
    string   = NKF.nkf('-e',"�͡����桹��¶��")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['�͡�','��','�桹','��','¶��'].collect{|s|NKF.nkf('-e', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_eucjp_withlatin()
    string   = NKF.nkf('-e',"�����ʳ���\"I\'m a high-school student.\"�Τ褦�ʲ�ʸ��ޤ�ʸ��")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ['�����ʳ���','"','I\'m ','a ','high-school ','student','.','"','�Τ褦��','��ʸ��','�ޤ�','ʸ','��'].collect{|s|NKF.nkf('-e', s)}
    assert_equal(expected, string.to_word)
  end
  # Shift_JIS tests.  EoL is CRLF.
  def test_to_word_ja_sjis_kanhira()
    string   = NKF.nkf('-s',"���٤��������ꤷ����")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = ['���٤���','������ꤷ��','��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_sjis_macronhira()
    string   = NKF.nkf('-s',"�롼���롣")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = ['�롼����','��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_sjis_macronkata_trail()
    string   = NKF.nkf('-s',"�ա������Υ�������")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = ['�ա�������','������','��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_sjis_macronkata_between()
    string   = NKF.nkf('-s',"�ǡ����򥽡��ȡ�")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = ['�ǡ�����','������','��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_sjis_repeatkan()
    string   = NKF.nkf('-s',"�͡����桹��¶��")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = ['�͡�','��','�桹','��','¶��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_word)
  end
  def test_to_word_ja_sjis_withlatin()
    string   = NKF.nkf('-s',"�����ʳ���\"I\'m a high-school student.\"�Τ褦�ʲ�ʸ��ޤ�ʸ��")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = ['�����ʳ���','"','I\'m ','a ','high-school ','student','.','"','�Τ褦��','��ʸ��','�ޤ�','ʸ','��'].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_word)
  end

#   def test_count_word_en_ascii_cr()
#   end
#   def test_count_word_en_ascii_lf()
#   end
#   def test_count_word_en_ascii_crlf()
#   end
##   def test_count_word_ja_eucjp_cr()
##   end
#   def test_count_word_ja_eucjp_lf()
#   end
##   def test_count_word_ja_eucjp_crlf()
##   end
#   def test_count_word_ja_sjis_cr()
#   end
##   def test_count_word_ja_sjis_lf()
##   end
#   def test_count_word_ja_sjis_crlf()
#   end

  # to_line tests.
  def test_to_line_en_ascii_cr()
    string = "Foo bar.  \r\rBaz quux.\r"
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\r"
    expected = ["Foo bar.  \r","\r","Baz quux.\r"]
    assert_equal(expected, string.to_line)
  end
  def test_to_line_en_ascii_lf()
    string = "Foo bar.  \n\nBaz quux.\n"
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\n"
    expected = ["Foo bar.  \n","\n","Baz quux.\n"]
    assert_equal(expected, string.to_line)
  end
  def test_to_line_en_ascii_crlf()
    string = "Foo bar.  \r\n\r\nBaz quux.\r\n"
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\r\n"
    expected = ["Foo bar.  \r\n","\r\n","Baz quux.\r\n"]
    assert_equal(expected, string.to_line)
  end
  def test_to_line_ja_eucjp_lf()
    string = NKF.nkf('-e', "����\n����\n\n��������\n")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = ["����\n","����\n","\n","��������\n"].collect{|s|NKF.nkf('-e', s)}
    assert_equal(expected, string.to_line)
  end
  def test_to_line_ja_sjis_cr()
    string = NKF.nkf('-s', "����\r����\r\r��������\r")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r"
    expected = ["����\r","����\r","\r","��������\r"].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_line)
  end
  def test_to_line_ja_sjis_crlf()
    string = NKF.nkf('-s', "����\r\n����\r\n\r\n��������\r\n")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = ["����\r\n","����\r\n","\r\n","��������\r\n"].collect{|s|NKF.nkf('-s', s)}
    assert_equal(expected, string.to_line)
  end
  def test_count_line_en_ascii_cr()
    string = "Foo bar.  \r\rBaz quux.\r"
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\r"
    expected = 3
    assert_equal(expected, string.count_line)
  end
  def test_count_line_en_ascii_lf()
    string = "Foo bar.  \n\nBaz quux.\n"
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\n"
    expected = 3
    assert_equal(expected, string.count_line)
  end
  def test_count_line_en_ascii_crlf()
    string = "Foo bar.  \r\n\r\nBaz quux.\r\n"
    string.extend DocDiff::StringPlus
    string.lang = "English"
    string.enc = "ASCII"
    string.eol = "\r\n"
    expected = 3
    assert_equal(expected, string.count_line)
  end
  def test_count_line_ja_eucjp_lf()
    string = NKF.nkf('-e', "����\n����\n\n��������\n")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "EUC-JP"
    string.eol = "\n"
    expected = 4
    assert_equal(expected, string.count_line)
  end
  def test_count_line_ja_sjis_cr()
    string = NKF.nkf('-s', "����\r����\r\r��������\r")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r"
    expected = 4
    assert_equal(expected, string.count_line)
  end
  def test_count_line_ja_sjis_crlf()
    string = NKF.nkf('-s', "����\r\n����\r\n\r\n��������\r\n")
    string.extend DocDiff::StringPlus
    string.lang = "Japanese"
    string.enc = "Shift_JIS"
    string.eol = "\r\n"
    expected = 4
    assert_equal(expected, string.count_line)
  end

  # to_phrase
  # count_phrase
  # to_paragraph
  # count_paragraph

end
