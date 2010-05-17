require 'progressbar'

class MediaConverter

  def genertate_mp3 input_file, output_file
    command = "ffmpeg -y -i #{input_file} -vn -ar 44100 -ac 2 -ab 192 -f mp3 #{output_file} 2>&1"

    execute("ffmpeg", command)
  end

  def generate_flv input_file, output_file
    command = "ffmpeg -i #{input_file} -ab 56 -ar 44100 -b 200 -r 15 -s 320x240 -f flv #{output_file} 2>&1"

    execute("ffmpeg", command)
  end

  def dump_mms_stream url, name
    command = "-dumpstream -dumpfile #{name}.wma #{url} 2>&1"

    execute("mplayer", command)
  end

  def extract_wav name
    command = "-vo null -vc dummy -ao pcm:file=#{name}.wav #{name}.wma"

    execute("mplayer", command)
  end

  def convert_wav_to_mp3 name
    command = "-ab 128 -i #{name}.wav #{name}.mp3"

    execute("ffmpeg", command)
  end

  protected

  def execute(tool, command)
    progress_bar = ProgressBar.new("media converter", 100)

    IO.popen("#{tool} #{command}") do |pipe|
      duration = 0

      pipe.each("\r") do |line|
        p line
        
        duration = next_position(duration, line) do |position|
          progress_bar.set(position) if progress_bar.current != position
        end
      end
    end

    progress_bar.finish
  end

  def next_position duration, line
    if line =~ /Duration: (\d{2}):(\d{2}):(\d{2}).(\d{1})/
      duration = (($1.to_i * 60 + $2.to_i) * 60 + $3.to_i) * 10 + $4.to_i
    end

    if line =~ /time=(\d+).(\d+)/
      if duration != 0
        pos = ($1.to_i * 10 + $2.to_i) * 100 / duration
      else
        pos = 0
      end

      pos = 100 if pos > 100

      yield(pos)
    end

    duration
  end
end

converter = MediaConverter.new

#converter.genertate_mp3 "../stream.wmv", "stream.mp3"

#converter.dump_mms_stream "mms://208.100.43.199/MTVL_S0016/stream.wmv?t=PHJvb3QgYT0iaXRiXzQ4ZmIwNzZkNzY2OTVkNmE2MjI1OWQwMTZhMGFhZjFmIiBiPSIyNzczNyIgYz0iNzEuMjI1LjQ3LjQ2IiBkPSIxMzcwMjQiIGU9IjYwMCIgZj0iRzpcMDAwXDEzN1wwMjRcNjAwLndtdiIgZz0iNjAwIiBoPSItMSIgaT0iMSIgaj0iMCIgaz0iaHR0cDovLzE3NC4xNDIuMTg1LjgwL3N0YXQvd21zX3N0YXRpc3RpY3MuYXNteCIgbD0ibWF0dmlsXzUyNTMxYjRhMDEwYTM0ZDI3YzBjOWUzMjgxM2JjNzI0IiBtPSItMSIgLz4%3d", "test"

#converter.extract_wav("test")
#
converter.convert_wav_to_mp3("test")

