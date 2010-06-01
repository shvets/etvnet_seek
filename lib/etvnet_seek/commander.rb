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
    elsif @options[:channels] == true
      'channels'
    elsif @options[:catalog] == true
      'catalog'
    elsif @options[:new_items] == true
      'new_items'
    elsif @options[:premiere] == true
      'premiere'
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

    optparse = OptionParser.new do |opts|
      # Set a banner, displayed at the top
      # of the help screen.
      opts.banner = "Usage: etvnet-seek [options] keywords"

      options[:search] = false
      opts.on('-s', '--search', 'Display Search Menu') do
        options[:search] = true
      end

      options[:runglish] = false
      opts.on('-r', '--runglish', 'Enter russian keywords in translit') do
        options[:runglish] = true
      end

      options[:best_hundred] = false
      opts.on('-b', '--best-hundred', 'Display Best 100 Menu') do
        options[:best_hundred] = true
      end

      options[:channels] = false
      opts.on('-c', '--channels', 'Display Channels Menu') do
        options[:channels] = true
      end

      options[:catalog] = false
      opts.on('-a', '--catalog', 'Display Catalog Menu') do
        options[:catalog] = true
      end

      options[:main] = false
      opts.on('-m', '--main', 'Display Main Menu') do
        options[:main] = true
      end

      options[:new_items] = false
      opts.on('-n', '--new_items', 'New Items Menu') do
        options[:new_items] = true
      end

      options[:premiere] = false
      opts.on('-p', '--premiere', 'Premiere of the Week Menu') do
        options[:premiere] = true
      end

      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end

    optparse.parse!

    if options[:runglish] && !options[:search]
      puts "Please use -r option together with -s option."
      exit
    end

    options
  end

end