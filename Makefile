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
rust-parser: $(RUST_DIR)/src/main.rs $(RUST_DIR)/Cargo.toml
	cargo build --release $(CARGOFLAGS) --manifest-path $(RUST_DIR)/Cargo.toml
	cp $(RUST_DIR)/target/release/rust-parse rust-parser

clean:
	rm -rf $(CLEAN)
