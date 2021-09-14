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

RUST_DIR = rust-parse
ifndef BUILD_ENV
BUILD_ENV = debug
endif
CARGOFLAGS += --target $(TARGET)
CARGOFLAGS += --manifest-path $(RUST_DIR)/Cargo.toml
# Usage: TARGET=<target-triplet> BUILD_ENV=release make rust-parser
rust-parser: $(RUST_DIR)/src/main.rs $(RUST_DIR)/Cargo.toml
	cargo build $(CARGOFLAGS)
	cp $(RUST_DIR)/target/$(TARGET)/$(BUILD_ENV)/rust-parse rust-parser

clean:
	rm -rf $(CLEAN)

dummy-repos:
	mkdir -p dummy-repos
	echo '2 + 2' > dummy-repos/test.rb

dummy-filelist:
	echo "dummy-repos/test.rb" > dummy-filelist
