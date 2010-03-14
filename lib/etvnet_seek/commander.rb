class Commander
  attr_accessor :mode
  
  def initialize
    @options = parse_options
  end

  def search_mode?
    @options[:search]
  end

  def runglish_mode?
    @options[:runglish]
  end

  def get_initial_mode
    if @options[:search] == true
      'search'
    elsif @options[:best_hundred] == true
      'best_hundred'
    elsif @options[:we_recommend] == true
      'we_recommend'
    elsif @options[:channels] == true
      'channels'
    elsif @options[:catalog] == true
      'catalog'
    else
      'main'
    end
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

      options[:best_hundred] = false
      opts.on( '-b', '--best-hundred', 'Display Best 100 Menu' ) do
        options[:best_hundred] = true
      end

      options[:we_recommend] = false
      opts.on( '-w', '--we-recommend', 'Display We recommend Menu' ) do
        options[:we_recommend] = true
      end

      options[:channels] = false
      opts.on( '-c', '--channels', 'Display Channels Menu' ) do
        options[:channels] = true
      end

      options[:catalog] = false
      opts.on( '-a', '--catalog', 'Display Catalog Menu' ) do
        options[:popular] = true
      end

      options[:main] = false
      opts.on( '-m', '--main', 'Display Main Menu' ) do
        options[:main] = true
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

end