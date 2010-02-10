# Converts file names in directory recursively from Russian to Runglish.
#
# Runglish stands for Russian text in Latin letters.

# -*- encoding: utf-8 -*-

if RUBY_VERSION < "1.9"
  $KCODE = 'u'
end

class Runglish

  LOWER_SINGLE = {
    "і"=>"i", "ґ"=>"g", "ё"=>"yo", "№"=>"#", "є"=>"e", "ї"=>"yi",
    "а"=>"a", "б"=>"b", "в"=>"v", "г"=>"g", "д"=>"d", "е"=>"e", "ж"=>"zh",
    "з"=>"z", "и"=>"i", "й"=>"y", "к"=>"k", "л"=>"l", "м"=>"m", "н"=>"n", "о"=>"o", "п"=>"p", "р"=>"r",
    "с"=>"s", "т"=>"t", "у"=>"u", "ф"=>"f", "х"=>"h", "ц"=>"ts", "ч"=>"ch", "ш"=>"sh", "щ"=>"sch",
    "ъ"=>"'", "ы"=>"y", "ь"=>"", "э"=>"e", "ю"=>"yu", "я"=>"ya",
  }

  LOWER_MULTI = {
    "ье"=>"ie",
    "ьё"=>"ie",
  }

  UPPER_SINGLE = {
    "Ґ"=>"G", "Ё"=>"YO", "Є"=>"E", "Ї"=>"YI", "І"=>"I",
    "А"=>"A", "Б"=>"B", "В"=>"V", "Г"=>"G", "Д"=>"D", "Е"=>"E", "Ж"=>"ZH",
    "З"=>"Z", "И"=>"I", "Й"=>"Y", "К"=>"K", "Л"=>"L", "М"=>"M", "Н"=>"N", "О"=>"O", "П"=>"P", "Р"=>"R",
    "С"=>"S", "Т"=>"T", "У"=>"U", "Ф"=>"F", "Х"=>"H", "Ц"=>"TS", "Ч"=>"CH", "Ш"=>"SH", "Щ"=>"SCH",
    "Ъ"=>"'", "Ы"=>"Y", "Ь"=>"", "Э"=>"E", "Ю"=>"YU", "Я"=>"YA",
  }

  UPPER_MULTI = {
    "ЬЕ"=>"IE",
    "ЬЁ"=>"IE",
  }

  LOWER = (LOWER_SINGLE.merge(LOWER_MULTI)).freeze
  UPPER = (UPPER_SINGLE.merge(UPPER_MULTI)).freeze
  MULTI_KEYS = (LOWER_MULTI.merge(UPPER_MULTI)).keys.sort_by {|s| s.length}.reverse.freeze


  LOWER_SINGLE_2 = {
    "i"=>"і", "g"=>"ґ", "#"=>"№", "e"=>"є",
    "a"=>"а", "b"=>"б", "v"=>"в", "g"=>"г", "d"=>"д", "e"=>"е", "z"=>"з", "i"=>"и",
    "k"=>"к", "l"=>"л", "m"=>"м", "n"=>"н", "o"=>"о", "p"=>"п", "r"=>"р", "s"=>"с", "t"=>"т",
    "u"=>"у", "f"=>"ф", "h"=>"х", "y"=>"ъ", "y"=>"ы"
  }
  LOWER_MULTI_2 = {
    "yo"=>"ё",
    "yi"=>"ї",
    "ii"=>"й",
    "zh"=>"ж",
    "ts"=>"ц",
    "ch"=>"ч",
    "sh"=>"ш",
    "sch"=>"щ",
    "ye"=>"э",
    "yu"=>"ю",
    "ya"=>"я",
    "ie"=>"ье"
  }

  UPPER_SINGLE_2 = {
    "G"=>"Ґ", "Є"=>"E", "I"=>"І",
    "A"=>"А", "B"=>"Б", "V"=>"В", "G"=>"Г", "D"=>"Д", "E"=>"Е", "Z"=>"З", "I"=>"И",
    "K"=>"К", "L"=>"Л", "M"=>"М", "N"=>"Н", "O"=>"О", "P"=>"П", "R"=>"Р",
    "S"=>"С", "T"=>"Т", "U"=>"У", "F"=>"Ф", "H"=>"Х", "'"=>"Ъ", "Y"=>"Ы"
  }

  UPPER_MULTI_2 = {
    "YO"=>"Ё",
    "YI"=>"Ї",
    "II"=>"Й",
    "ZH"=>"Ж",
    "TS"=>"Ц",
    "CH"=>"Ч",
    "SH"=>"Ш",
    "SCH"=>"Щ",
    "YE"=>"Э",
    "YU"=>"Ю",
    "YA"=>"Я",
    "IE"=>"ЬЕ"
  }

  LOWER_2 = (LOWER_SINGLE_2.merge(LOWER_MULTI_2)).freeze
  UPPER_2 = (UPPER_SINGLE_2.merge(UPPER_MULTI_2)).freeze
  MULTI_KEYS_2 = (LOWER_MULTI_2.merge(UPPER_MULTI_2)).keys.sort_by {|s| s.length}.reverse.freeze

  # Transliterate a string with russian characters
  #
  # Возвращает строку, в которой все буквы русского алфавита заменены на похожую по звучанию латиницу
  def ru_to_lat(str)
    chars = str.scan(%r{#{MULTI_KEYS.join '|'}|\w|.})

    result = ""

    chars.each_with_index do |char, index|
      if UPPER.has_key?(char) && LOWER.has_key?(chars[index+1])
        # combined case
        result << UPPER[char].downcase.capitalize
      elsif UPPER.has_key?(char)
        result << UPPER[char]
      elsif LOWER.has_key?(char)
        result << LOWER[char]
      else
        result << char
      end
    end

    result
  end

  def lat_to_ru(str)
    chars = str.scan(%r{#{MULTI_KEYS_2.join '|'}|\w|.})

    result = ""

    chars.each_with_index do |char, index|
      if UPPER_2.has_key?(char) && LOWER_2.has_key?(chars[index+1])
        # combined case
        result << UPPER_2[char].downcase.capitalize
      elsif UPPER_2.has_key?(char)
        result << UPPER_2[char]
      elsif LOWER_2.has_key?(char)
        result << LOWER_2[char]
      else
        result << char
      end
    end

    result
  end
end


