# This script computes totals of .rb files in the repos/ directory

files = 0
lines = 0
Dir['repos/**/*.rb'].each do |f|
    files += 1
    lines += File.read(f).lines.count
end

content = <<~HERE
files: #{files}
lines: #{lines}
HERE

puts content

File.write("stats", content)
