# Converts file names in directory recursively from Russian to Runglish.
#
# Runglish stands for Russian text in Latin letters.

class Runglish
  RUSSIAN_TABLE = [
    '\u0430', '\u0431', '\u0432', '\u0433', '\u0434', '\u0435', '\u0436', '\u0437',
    '\u0438', '\u0439', '\u043a', '\u043b', '\u043c', '\u043d', '\u043e', '\u043f',
    '\u0440', '\u0441', '\u0442', '\u0443', '\u0444', '\u0445', '\u0446', '\u0447',
    '\u0448', '\u0449', '\u044a', '\u044b', '\u044c', '\u044d', '\u044e', '\u044f',
    '\u0451',
    '\u0401',
    '\u0410', '\u0411', '\u0412', '\u0413', '\u0414', '\u0415', '\u0416', '\u0417',
    '\u0418', '\u0419', '\u041a', '\u041b', '\u041c', '\u041d', '\u041e', '\u041f',
    '\u0420', '\u0421', '\u0422', '\u0423', '\u0424', '\u0425', '\u0426', '\u0427',
    '\u0428', '\u0429', '\u042a', '\u042b', '\u042c', '\u042d', '\u042e', '\u042f'
  ]


  ENGLISH_TABLE = [
    "a", "b", "v", "g", "d", "e", "zh", "z", "i", "y", "k", "l", "m", "n", "o", "p", "r",
    "s", "t", "u", "f", "h", "c", "ch", "sh", "s'h", "''", "yi", "'", "ye", "yu", "ya",
    "yo",
    "YO",
    "A", "B", "V", "G", "D", "E", "Zh", "Z", "I", "Y", "K", "L", "M", "N", "O", "P", "R",
    "S", "T", "U", "F", "H", "C", "Ch", "Sh", "S'h", "''", "Yi", "'", "Ye", "Yu", "Ya"
  ]

  ENGLISH_RUSSIAN_MAP = Hash[*ENGLISH_TABLE.zip(RUSSIAN_TABLE).flatten]

  def translate(old_text)
    new_text = ""

    old_text.each_char do |ch|
       new_ch = ENGLISH_RUSSIAN_MAP[ch].nil? ? ch : ENGLISH_RUSSIAN_MAP[ch]

      new_text += new_ch
    end

    new_text
  end
end


