repos:
	ruby download.rb
CLEAN += repos gems

stats:
	ruby stats.rb
CLEAN += stats

filelist:
	ruby filelist.rb
CLEAN += filelist

repos.zip: repos stats filelist
	zip -r -q repos.zip repos/ stats filelist
CLEAN += repos.zip

clean:
	rm -rf $(CLEAN)
