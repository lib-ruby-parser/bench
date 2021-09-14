# This script build a filelist to simplify writing benchmark runners

content = Dir['repos/**/*.rb'].join("\n")
File.write("filelist", content)
