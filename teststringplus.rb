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
    s      = "foo bar"
    s.extend DocDiff::StringPlus
    s.lang = "English"
    s.enc  = "ASCII"
    s.eol  = "\n"
    expected = ['f','o','o',' ','b','a','r']
    assert_equal(expected, s.to_char)
  end
  def test_to_char_ja_eucjp()
    s      = "�������ʥ�������"
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc  = "EUC-JP"
    s.eol  = "\n"
    expected = ['��','��','��','��','��','��','��','��']
    assert_equal(expected, s.to_char)
  end
  def test_to_char_ja_sjis()
    s = NKF.nkf('-s', "�������ʥ�������")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc  = "Shift_JIS"
    s.eol  = "\n"
    expected = ['��','��','��','��','��','��','��','��'].collect{|st|
      NKF.nkf('-s', st)
    }
    assert_equal(expected, s.to_char)
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
    s   = "foo bar baz quux."
    s.extend DocDiff::StringPlus
    s.lang = "English"
    s.enc = "ASCII"
    s.eol = "\n"
    expected = ['foo ','bar ','baz ','quux','.']
    assert_equal(expected, s.to_word)
  end
  def test_to_word_en_ascii_lf_hyphen()
    s   = "Mr. Black, he\'s a high-school student."
    s.extend DocDiff::StringPlus
    s.lang = "English"
    s.enc = "ASCII"
    s.eol = "\n"
    expected = ["Mr. ","Black",", ","he\'s ","a ","high-school ","student","."]
    assert_equal(expected, s.to_word)
  end
  # EUC-JP encoding.  EoL is LF.
  def test_to_word_ja_eucjp_kanhira()
    s   = NKF.nkf('-e',"���٤��������ꤷ����")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "EUC-JP"
    s.eol = "\n"
    expected = ['���٤���','������ꤷ��','��'].collect{|st|
      NKF.nkf('-e', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_eucjp_macronhira()
    s   = NKF.nkf('-e',"�롼���롣")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "EUC-JP"
    s.eol = "\n"
    expected = ['�롼����','��'].collect{|st|
      NKF.nkf('-e', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_eucjp_macronkata_trail()
    s   = NKF.nkf('-e',"�ա������Υ�������")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "EUC-JP"
    s.eol = "\n"
    expected = ['�ա�������','������','��'].collect{|st|
      NKF.nkf('-e', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_eucjp_macronkata_between()
    s   = NKF.nkf('-e',"�ǡ����򥽡��ȡ�")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "EUC-JP"
    s.eol = "\n"
    expected = ['�ǡ�����','������','��'].collect{|st|
      NKF.nkf('-e', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_eucjp_repeatkan()
    s   = NKF.nkf('-e',"�͡����桹��¶��")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "EUC-JP"
    s.eol = "\n"
    expected = ['�͡�','��','�桹','��','¶��'].collect{|st|
      NKF.nkf('-e', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_eucjp_withlatin()
    s = NKF.nkf('-e',"�����ʳ���\"I\'m a high-school student.\"�Τ褦�ʲ�ʸ��ޤ�ʸ��")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc  = "EUC-JP"
    s.eol  = "\n"
    expected = ['�����ʳ���','"','I\'m ','a ','high-school ','student','.','"',
                '�Τ褦��','��ʸ��','�ޤ�','ʸ','��'].collect{|st|
      NKF.nkf('-e', st)
    }
    assert_equal(expected, s.to_word)
  end
  # Shift_JIS tests.  EoL is CRLF.
  def test_to_word_ja_sjis_kanhira()
    s   = NKF.nkf('-s',"���٤��������ꤷ����")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "Shift_JIS"
    s.eol = "\r\n"
    expected = ['���٤���','������ꤷ��','��'].collect{|st|
      NKF.nkf('-s', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_sjis_macronhira()
    s   = NKF.nkf('-s',"�롼���롣")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "Shift_JIS"
    s.eol = "\r\n"
    expected = ['�롼����','��'].collect{|st|
      NKF.nkf('-s', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_sjis_macronkata_trail()
    s   = NKF.nkf('-s',"�ա������Υ�������")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "Shift_JIS"
    s.eol = "\r\n"
    expected = ['�ա�������','������','��'].collect{|st|
      NKF.nkf('-s', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_sjis_macronkata_between()
    s   = NKF.nkf('-s',"�ǡ����򥽡��ȡ�")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "Shift_JIS"
    s.eol = "\r\n"
    expected = ['�ǡ�����','������','��'].collect{|st|
      NKF.nkf('-s', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_sjis_repeatkan()
    s   = NKF.nkf('-s',"�͡����桹��¶��")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "Shift_JIS"
    s.eol = "\r\n"
    expected = ['�͡�','��','�桹','��','¶��'].collect{|st|
      NKF.nkf('-s', st)
    }
    assert_equal(expected, s.to_word)
  end
  def test_to_word_ja_sjis_withlatin()
    s   = NKF.nkf('-s',"�����ʳ���\"I\'m a high-school student.\"�Τ褦�ʲ�ʸ��ޤ�ʸ��")
    s.extend DocDiff::StringPlus
    s.lang = "Japanese"
    s.enc = "Shift_JIS"
    s.eol = "\r\n"
    expected = ['�����ʳ���','"','I\'m ','a ','high-school ','student','.','"',
                '�Τ褦��','��ʸ��','�ޤ�','ʸ','��'].collect{|st|
      NKF.nkf('-s', st)
    }
    assert_equal(expected, s.to_word)
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
    s = "Foo bar.  \r\rBaz quux.\r"
    s.extend DocDiff::StringPlus
    s.lang = "English"
    s.enc = "ASCII"
    s.eol = "\r"
    expected = ["Foo bar.  \r","\r","Baz quux.\r"]
    assert_equal(expected, s.to_line)
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
