#[cfg(feature = "jemallocator")]
extern crate jemallocator;
extern crate lib_ruby_parser;
#[cfg(feature = "jemallocator")]
#[global_allocator]
static GLOBAL: jemallocator::Jemalloc = jemallocator::Jemalloc;

use lib_ruby_parser::{Parser, ParserOptions};
use std::time::Instant;

fn files_to_parse() -> Vec<FileToParse> {
    let filelist_path = std::env::var("FILELIST_PATH").unwrap_or_else(|_| {
        println!(
            "Usage:
FILELIST_PATH=<path/to/filelist> ./rust-parser"
        );
        std::process::exit(1);
    });
    let filelist = std::fs::read_to_string(&filelist_path).unwrap();

    filelist
        .lines()
        .map(|filepath| FileToParse::new(filepath))
        .collect::<Vec<_>>()
}

struct FileToParse {
    filepath: String,
    content: Vec<u8>,
}

impl FileToParse {
    fn new(filepath: &str) -> Self {
        Self {
            filepath: filepath.to_owned(),
            content: std::fs::read(filepath).unwrap(),
        }
    }

    fn parse(self) {
        let Self { filepath, content } = self;
        let options = ParserOptions {
            buffer_name: filepath,
            decoder: None,
            token_rewriter: None,
            record_tokens: false,
        };
        Parser::new(content, options).do_parse();
    }
}

fn main() {
    let files_to_parse = files_to_parse();

    let start = Instant::now();
    for file_to_parse in files_to_parse {
        file_to_parse.parse();
    }
    let end = Instant::now();
    let diff = (end - start).as_secs_f64();
    println!("{:.10}", diff)
}
