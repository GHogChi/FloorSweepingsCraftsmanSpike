module Loggable
  $loggable_index = 1
  def get_filelogger(dir)
    dir = dir.chomp
    dir = dir + '/' if dir[dir.size - 1] != '/'
    log_name = "#{dir}#{self.class.name}-#{$loggable_index}.log"
    puts "log_name: #{log_name}"
    $loggable_index += 1
    pf = PatternFormatter.new(:pattern => "[%l] %d :: %m")
    f = FileOutputter.new log_name, {:filename => log_name, :truncate => false, :formatter => pf}
    
    log = Logger.new log_name
    log.outputters = f
    log
  end
end

