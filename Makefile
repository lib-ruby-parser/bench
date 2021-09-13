repos:
	ruby download.rb

strip-out: repos
	ruby strip.rb

repos.zip: strip-out
	zip -r -q repos.zip repos/ strip-out

clean:
	rm -rf gems
	rm -rf repos
	rm -rf strip-out
	rm -rf repos.zip
