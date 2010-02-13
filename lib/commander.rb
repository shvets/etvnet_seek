class Commander
  attr_accessor :mode
  
  def initialize
    @options = parse_options
    
    @mode = get_mode @options
  end

  def search_mode?
    @mode == 'search'
  end

  def main_menu_mode?
    @mode == 'main'
  end

  def channels_mode?
    @mode == 'channels'
  end

  def runglish_mode?
    @options[:runglish]
  end

  private

  def parse_options
    # This hash will hold all of the options
    # parsed from the command-line by
    # OptionParser.
    options = {}

    optparse = OptionParser.new do|opts|
      # Set a banner, displayed at the top
      # of the help screen.
      opts.banner = "Usage: etvnet_seek [options] keywords"

      options[:search] = false
      opts.on( '-s', '--search', 'Display Search Menu' ) do
        options[:search] = true
      end

      options[:runglish] = false
      opts.on( '-r', '--runglish', 'Enter russian keywords in translit' ) do
        options[:runglish] = true
      end

      options[:main] = false
      opts.on( '-m', '--main', 'Display Main Menu' ) do
        options[:main] = true
      end

      options[:best_ten] = false
      opts.on( '-b', '--best-ten', 'Display Best 10 Menu' ) do
        options[:best_ten] = true
      end

      options[:popular] = false
      opts.on( '-p', '--popular', 'Display Popular Menu' ) do
        options[:popular] = true
      end

      options[:we_recommend] = false
      opts.on( '-w', '--we-recommend', 'Display We recommend Menu' ) do
        options[:we_recommend] = true
      end

      options[:channels] = false
      opts.on( '-c', '--channels', 'Display Channels Menu' ) do
        options[:channels] = true
      end

      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end

    optparse.parse!

    options
  end

  def get_mode options
    if options[:search] == true
      'search'
    elsif options[:best_ten] == true
      'best_ten'
    elsif options[:popular] == true
      'popular'
    elsif options[:we_recommend] == true
      'we_recommend'
    elsif options[:channels] == true
      'channels'
    else
      'main'
    end
  end

end