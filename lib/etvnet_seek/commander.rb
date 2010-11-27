class Commander
  attr_accessor :mode

  def initialize
    @options = parse_options
  end

  def search_mode?
    @options[:search]
  end

  def translit_mode?
    @options[:translit]
  end

  def get_initial_mode
    if @options[:search] or @options[:translit]
      'search'
    elsif @options[:best_hundred]
      'best_hundred'
    elsif @options[:top_this_week]
      'top_this_week'
    elsif @options[:channels]
      'channels'
    elsif @options[:catalog]
      'catalog'
    elsif @options[:new_items]
      'new_items'
    elsif @options[:premiere]
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
      opts.on('-s', '--search', 'Search programs') do
        options[:search] = true
      end

      options[:translit] = false
      opts.on('-t', '--translit', 'Search programs in translit') do
        options[:translit] = true
      end

      options[:best_hundred] = false
      opts.on('-b', '--best-hundred', 'Best 100 Menu') do
        options[:best_hundred] = true
      end

      options[:top_this_week] = false
      opts.on('-w', '--top_this_week', 'Top This Week') do
        options[:top_this_week] = true
      end

      options[:channels] = false
      opts.on('-c', '--channels', 'Channels Menu') do
        options[:channels] = true
      end

      options[:catalog] = false
      opts.on('-a', '--catalog', 'Catalog Menu') do
        options[:catalog] = true
      end

      options[:main] = false
      opts.on('-m', '--main', 'Main Menu') do
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

#      opts.on('-r', '--require', '') do
#      end
#
#      opts.on('-f', '--format', '') do
#      end
#
#      opts.on('-e', '--example', '') do
#      end
    end

    optparse.parse!

#    if options[:runglish] && !options[:search]
#      puts "Please use -r option together with -s option."
#      exit
#    end

    options
  end

end
