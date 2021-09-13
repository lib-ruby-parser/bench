# This script removes all non-Ruby files from the `repos` directory
# It must be executed after running `downloads.rb` script
require 'fileutils'

Dir['repos/**/*'].each do |f|
    # ignore directories
    next if File.directory?(f)

    # ignore Ruby files
    next if File.extname(f) == '.rb'

    FileUtils.rm(f)
end

files = 0
lines = 0
Dir['repos/**/*.rb'].each do |f|
    files += 1
    lines += File.read(f).lines.count
end

File.write("strip-out", "files: #{files}, lines: #{lines}")
