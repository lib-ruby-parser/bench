filelist = File.read(ENV['FILELIST_PATH']).split("\n")
files = filelist.map { |filepath| File.read(filepath) }
require 'ripper'

GC.disable

def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
end

start = now
files.each do |file|
    Ripper.sexp(file)
end

puts "#{now - start}"
