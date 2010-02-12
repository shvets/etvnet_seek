# Converts file names in directory recursively from Russian to Runglish.
#
# Runglish stands for Russian text in Latin letters.

# -*- encoding: utf-8 -*-

$KCODE = 'u' if RUBY_VERSION < "1.9"

module Runglish

  class Converter
    def initialize(lower_single, lower_multi, upper_single, upper_multi)
      @lower_single = lower_single
      @lower_multi = lower_multi
      @upper_single = upper_single
      @upper_multi = upper_multi

      @lower = (@lower_single.merge(@lower_multi)).freeze
      @upper = (@upper_single.merge(@upper_multi)).freeze
      @multi_keys = (@lower_multi.merge(@upper_multi)).keys.sort_by {|s| s.length}.reverse.freeze
    end

    # Transliterate a string
    def transliterate(str)
      chars = str.scan(%r{#{@multi_keys.join '|'}|\w|.})

      result = ""

      chars.each_with_index do |char, index|
        if @upper.has_key?(char) && @lower.has_key?(chars[index+1]) # combined case
          result << @upper[char].downcase.capitalize
        elsif @upper.has_key?(char)
          result << @upper[char]
        elsif @lower.has_key?(char)
          result << @lower[char]
        else
          result << char
        end
      end

      result
    end
  end

  class RusToLatConverter < Converter
    def initialize
      lower_single = {
        "і"=>"i", "ґ"=>"g", "ё"=>"yo", "№"=>"#", "є"=>"e", "ї"=>"yi",
        "а"=>"a", "б"=>"b", "в"=>"v", "г"=>"g", "д"=>"d", "е"=>"e", "ж"=>"zh",
        "з"=>"z", "и"=>"i", "й"=>"y", "к"=>"k", "л"=>"l", "м"=>"m", "н"=>"n", "о"=>"o", "п"=>"p", "р"=>"r",
        "с"=>"s", "т"=>"t", "у"=>"u", "ф"=>"f", "х"=>"h", "ц"=>"ts", "ч"=>"ch", "ш"=>"sh", "щ"=>"sch",
        "ъ"=>"'", "ы"=>"y", "ь"=>"", "э"=>"e", "ю"=>"yu", "я"=>"ya"
      }

      lower_multi = {
        "ье"=>"ie",
        "ьё"=>"ie"
      }

      upper_single = {
        "Ґ"=>"G", "Ё"=>"YO", "Є"=>"E", "Ї"=>"YI", "І"=>"I",
        "А"=>"A", "Б"=>"B", "В"=>"V", "Г"=>"G", "Д"=>"D", "Е"=>"E", "Ж"=>"ZH",
        "З"=>"Z", "И"=>"I", "Й"=>"Y", "К"=>"K", "Л"=>"L", "М"=>"M", "Н"=>"N", "О"=>"O", "П"=>"P", "Р"=>"R",
        "С"=>"S", "Т"=>"T", "У"=>"U", "Ф"=>"F", "Х"=>"H", "Ц"=>"TS", "Ч"=>"CH", "Ш"=>"SH", "Щ"=>"SCH",
        "Ъ"=>"'", "Ы"=>"Y", "Ь"=>"", "Э"=>"E", "Ю"=>"YU", "Я"=>"YA"
      }

      upper_multi = {
        "ЬЕ"=>"IE",
        "ЬЁ"=>"IE"
      }

      super(lower_single, lower_multi, upper_single, upper_multi)
    end
  end

  class LatToRusConverter < Converter
    def initialize
      lower_single = {
        "i"=>"і", "g"=>"ґ", "#"=>"№", "e"=>"є",
        "a"=>"а", "b"=>"б", "v"=>"в", "g"=>"г", "d"=>"д", "e"=>"е", "z"=>"з", "i"=>"и",
        "k"=>"к", "l"=>"л", "m"=>"м", "n"=>"н", "o"=>"о", "p"=>"п", "r"=>"р", "s"=>"с", "t"=>"т",
        "u"=>"у", "f"=>"ф", "h"=>"х", "y"=>"ъ", "y"=>"ы"
      }

      lower_multi = {
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

      upper_single = {
        "G"=>"Ґ", "Є"=>"E", "I"=>"І",
        "A"=>"А", "B"=>"Б", "V"=>"В", "G"=>"Г", "D"=>"Д", "E"=>"Е", "Z"=>"З", "I"=>"И",
        "K"=>"К", "L"=>"Л", "M"=>"М", "N"=>"Н", "O"=>"О", "P"=>"П", "R"=>"Р",
        "S"=>"С", "T"=>"Т", "U"=>"У", "F"=>"Ф", "H"=>"Х", "'"=>"Ъ", "Y"=>"Ы"
      }

      upper_multi = {
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

      super(lower_single, lower_multi, upper_single, upper_multi)
    end
  end
  
end


