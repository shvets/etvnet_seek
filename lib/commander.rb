class Commander
  attr_accessor :mode

  def initialize
    parse_options
    
    @mode = get_mode
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
    @options = {}

    optparse = OptionParser.new do|opts|
      # Set a banner, displayed at the top
      # of the help screen.
      opts.banner = "Usage: etvnet_seek [options] keywords"

      @options[:runglish] = false
      opts.on( '-r', '--runglish', 'Enter russian keywords in translit' ) do
        @options[:runglish] = true
      end

      @options[:main_menu] = false
      opts.on( '-m', '--main', 'Display Main Menu' ) do
        @options[:main_menu] = true
      end

      @options[:best_ten] = false
      opts.on( '-b', '--best-ten', 'Display Best 10 Menu' ) do
        @options[:best_ten] = true
      end

      @options[:popular] = false
      opts.on( '-p', '--popular', 'Display Popular Menu' ) do
        @options[:popular] = true
      end

      @options[:we_recommend] = false
      opts.on( '-w', '--we-recommend', 'Display We recommend Menu' ) do
        @options[:we_recommend] = true
      end

      @options[:channels] = false
      opts.on( '-c', '--channels', 'Display Channels Menu' ) do
        @options[:channels] = true
      end

      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end

    optparse.parse!
  end

  def get_mode
    mode = 'search'

    if @options[:main] == true
      mode = 'main'
    elsif @options[:best_ten] == true
      mode = 'best_ten'
    elsif @options[:popular] == true
      mode = 'popular'
    elsif @options[:we_recommend] == true
      mode = 'we_recommend'
    elsif @options[:channels] == true
      mode = 'channels'
    end

    mode
  end

end