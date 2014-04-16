# Rust-Empty: An Makefile to get started with Rust
# https://github.com/bvssvni/rust-empty
#
# The MIT License (MIT)
# 
# Copyright (c) 2014 Sven Nilsen
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

SHELL := /bin/bash

# The default make command.
# Change this to 'make lib' if you are building a library.
DEFAULT = make help

EXAMPLE_FILES = examples/*.rs
SOURCE_FILES = $(shell test -e src/ && find src/ -type f)

COMPILER = rustc

# For release:
  COMPILER_FLAGS = -O
# For debugging:
# COMPILER_FLAGS = -g

RUSTDOC = rustdoc 

# Extracts target from rustc.
TARGET = $(shell rustc --version | grep "host: " | cut -c 7-)
# TARGET = x86_64-unknown-linux-gnu
# TARGET = x86_64-apple-darwin 

all:
	$(DEFAULT)

help:
	clear \
	&& echo "--- rust-empty (0.2 009)" \
	&& echo "make run               - Runs executable" \
	&& echo "make exe               - Builds main executable" \
	&& echo "make lib               - Both static and dynamic library" \
	&& echo "make rlib              - Static library" \
	&& echo "make dylib             - Dynamic library" \
	&& echo "make test              - Tests library internally and externally" \
	&& echo "make test-internal     - Tests library internally" \
	&& echo "make test-external     - Tests library externally" \
	&& echo "make bench             - Benchmarks library internally and externally" \
	&& echo "make bench-internal    - Benchmarks library internally" \
	&& echo "make bench-external    - Benchmarks library externally" \
	&& echo "make doc               - Builds documentation for library" \
	&& echo "make git-ignore        - Setup files to be ignored by Git" \
	&& echo "make examples          - Builds examples" \
	&& echo "make cargo-lite-exe    - Setup executable package" \
	&& echo "make cargo-lite-lib    - Setup library package" \
	&& echo "make rust-ci-lib       - Setup Travis CI Rust library" \
	&& echo "make rust-ci-exe       - Setup Travis CI Rust executable" \
	&& echo "make rusti             - Setup 'rusti.sh' for interactive Rust" \
	&& echo "make loc               - Count lines of code in src folder" \
	&& echo "make nightly-install   - Installs Rust nightly built" \
	&& echo "make nightly-uninstall - Uninstalls Rust nightly built" \
	&& echo "make clean             - Deletes binaries and documentation." \
	&& echo "make clear-project     - WARNING: Deletes project files except 'Makefile'" \
	&& echo "make clear-git         - WARNING: Deletes Git setup" \

.PHONY: clean clear-git clear-project loc nightly-install nightly-uninstall run rusti

nightly-install:
	cd ~ \
    && curl -s http://www.rust-lang.org/rustup.sh | sudo sh

nightly-uninstall:
	cd ~ \
    && curl -s http://www.rust-lang.org/rustup.sh | sudo sh -s -- --uninstall

cargo-lite-exe: src src/main.rs
	( \
		test -e cargo-lite.conf \
		&& clear \
		&& echo "--- The file 'cargo-lite.conf' already exists" \
	) \
	|| \
	( \
		echo -e "deps = [\n]\n\n[build]\ncrate_root = \"src/main.rs\"\nrustc_args = []\n" > cargo-lite.conf \
		&& clear \
		&& echo "--- Created 'cargo-lite.conf' for executable" \
		&& cat cargo-lite.conf \
	)

cargo-lite-lib: src src/lib.rs
	( \
		test -e cargo-lite.conf \
		&& clear \
		&& echo "--- The file 'cargo-lite.conf' already exists" \
	) \
	|| \
	( \
		echo -e "deps = [\n]\n\n[build]\ncrate_root = \"src/lib.rs\"\ncrate_type = \"library\"\nrustc_args = []\n" > cargo-lite.conf \
		&& clear \
		&& echo "--- Created 'cargo-lite-conf' for library" \
		&& cat cargo-lite.conf \
	)

rust-ci-lib: src src/lib.rs
	( \
		test -e .travis.yml \
		&& clear \
		&& echo "--- The file '.travis.yml' already exists" \
	) \
	|| \
	( \
		echo -e "before_install:\n\t- yes | sudo add-apt-repository ppa:hansjorg/rust\n\t- sudo apt-get update\ninstall:\n\t- sudo apt-get install rust-nightly\nscript:\n\t- make lib\n" > .travis.yml \
		&& clear \
		&& echo "--- Created '.travis.yml' for library" \
		&& cat .travis.yml \
	)

rust-ci-exe: src src/main.rs
	( \
		test -e .travis.yml \
		&& clear \
		&& echo "--- The file '.travis.yml' already exists" \
	) \
	|| \
	( \
		echo -e "before_install:\n\t- yes | sudo add-apt-repository ppa:hansjorg/rust\n\t- sudo apt-get update\ninstall:\n\t- sudo apt-get install rust-nightly\nscript:\n\t- make exe\n" > .travis.yml \
		&& clear \
		&& echo "--- Created '.travis.yml' for executable" \
		&& cat .travis.yml \
	)

doc: src $(SOURCE_FILES)
	clear \
	&& $(RUSTDOC) src/lib.rs -L "target/$(TARGET)/lib" \
	&& clear \
	&& echo "--- Built documentation"

run: exe
	clear \
	&& cd bin/ \
	&& ./main

exe: bin src src/main.rs $(SOURCE_FILES)
	clear \
	&& $(COMPILER) --target $(TARGET) $(COMPILER_FLAGS) src/main.rs -o bin/main -L "target/$(TARGET)/lib" \
	&& echo "--- Built executable" \
	&& echo "--- Type 'make run' to run executable"

test: test-internal test-external
	clear \
	&& echo "--- Internal tests succeeded" \
	&& echo "--- External tests succeeded"

test-external: rlib src bin src/test.rs $(SOURCE_FILES)
	clear \
	&& $(COMPILER) --target $(TARGET) $(COMPILER_FLAGS) --test src/test.rs -o bin/test-external -L "target/$(TARGET)/lib" \
	&& echo "--- Built external test runner" \
	&& cd "bin/" \
	&& ./test-external

test-internal: rlib src bin $(SOURCE_FILES)
	clear \
	&& $(COMPILER) --target $(TARGET) $(COMPILER_FLAGS) --test src/lib.rs -o bin/test-internal -L "target/$(TARGET)/lib" \
	&& echo "--- Built internal test runner" \
	&& cd "bin/" \
	&& ./test-internal

bench: bench-internal bench-external

bench-external: test-external
	clear \
	&& bin/test-external --bench

bench-internal: test-internal
	clear \
	&& bin/test-internal --bench

lib: rlib dylib
	clear \
	&& echo "--- Built rlib" \
	&& echo "--- Built dylib" \
	&& echo "--- Type 'make test' to test library"

rlib: target-lib-dir src src/lib.rs $(SOURCE_FILES)
	clear \
	&& $(COMPILER) --target $(TARGET) $(COMPILER_FLAGS) --crate-type=rlib src/lib.rs -L "target/$(TARGET)/lib" --out-dir "target/$(TARGET)/lib/" \
	&& clear \
	&& echo "--- Built rlib" \
	&& echo "--- Type 'make test' to test library"

dylib: target-lib-dir src src/lib.rs $(SOURCE_FILES)
	clear \
	&& $(COMPILER) --target $(TARGET) $(COMPILER_FLAGS) --crate-type=dylib src/lib.rs -L "target/$(TARGET)/lib" --out-dir "target/$(TARGET)/lib/" \
	&& clear \
	&& echo "--- Built dylib" \
	&& echo "--- Type 'make test' to test library"

bin:
	mkdir -p bin

target-lib-dir:
	mkdir -p "target/$(TARGET)/lib/"

src:
	mkdir -p src

examples-dir:
	test -e examples \
	|| \
	( \
		mkdir examples \
		&& echo -e "fn main() {\n\tprintln!(\"Hello!\");\n}\n" > examples/hello.rs \
		&& clear \
		&& echo "--- Created examples folder" \
	)

rust-dir:
	mkdir -p .rust

git-ignore:
	( \
		test -e .gitignore \
		&& clear \
		&& echo "--- The file '.gitignore' already exists" \
	) \
	|| \
	( \
		echo -e ".DS_Store\n*~\n*#\n*.o\n*.so\n*.swp\n*.dylib\n*.dSYM\n*.dll\n*.rlib\n*.dummy\n*.exe\n*-test\n/bin/\n/doc/\n/target/\n/build/\n/.rust/\nrusti.sh\n" > .gitignore \
		&& clear \
		&& echo "--- Created '.gitignore' for git" \
		&& cat .gitignore \
	)

examples: $(EXAMPLE_FILES)

$(EXAMPLE_FILES): lib examples-dir
	$(COMPILER) --target $(TARGET) $(COMPILER_FLAGS) $@ -L "target/$(TARGET)/lib" --out-dir examples/ \
	&& clear \
	&& echo "--- Built examples"

src/main.rs:
	test -e src/main.rs \
	|| \
	( \
		echo -e "fn main() {\n\tprintln!(\"Hello world!\");\n}" > src/main.rs \
	)

src/test.rs:
	test -e src/test.rs \
	|| \
	( \
		touch src/test.rs \
	)

src/lib.rs:
	test -e src/lib.rs \
	|| \
	( \
		echo -e "#![crate_id = \"\"]\n#![deny(missing_doc)]\n\n//! Documentation goes here.\n" > src/lib.rs \
	)

clean:
	rm -rf "doc/"
	rm -f bin/*
	clear \
	&& echo "--- Deleted bin/* and doc/"

clear-project:
	rm -f "cargo-lite.conf"
	rm -f ".travis.yml"
	rm -f "rusti.sh"
	rm -rf "target/"
	rm -rf "src/"
	rm -rf "bin/"
	rm -rf "examples/"
	rm -rf "doc/"
	clear \
	&& echo "--- Removed all source files, binaries and documentation" \
	&& echo "--- Content in project folder" \
	&& ls -a

clear-git:
	rm -f ".gitignore"
	rm -rf ".git"
	clear \
	&& echo "--- Removed Git" \
	&& echo "--- Content in project folder" \
	&& ls -a

rusti: target-lib-dir
	( \
		test -e rusti.sh \
		&& clear \
		&& echo "--- The file 'rusti.sh' already exists" \
	) \
	|| \
	( \
		echo -e "#!/bin/bash\n\n#written by mcpherrin\n\nwhile true; do\n  echo -n \"> \"\n  read line\n  TMP=\"`mktemp r.XXXXXX`\"\n  $(COMPILER) - -o \$$TMP -L "target/$(TARGET)/lib/" <<EOF\n  #![feature(globs, macro_rules, phase, struct_variant)]\n  extern crate arena;\n  extern crate collections;\n  extern crate flate;\n  #[phase(syntax)] extern crate fourcc;\n  extern crate glob;\n  extern crate green;\n  extern crate hexfloat;\n  extern crate libc;\n  #[phase(syntax, link)] extern crate log;\n  extern crate native;\n  extern crate num;\n  extern crate rand;\n  extern crate rustc;\n  extern crate rustdoc;\n  extern crate rustuv;\n  extern crate semver;\n  extern crate serialize;\n  extern crate sync;\n  extern crate syntax;\n  extern crate term;\n  extern crate test;\n  extern crate time;\n  extern crate url;\n  extern crate uuid;\n  extern crate workcache;\n\n  fn main() {\n      let r = { \$$line };\n      println!(\"{:?}\", r);\n  }\nEOF\n  ./\$$TMP\n  rm \$$TMP\ndone" > rusti.sh \
		&& chmod +x rusti.sh \
		&& clear \
		&& echo "--- Created 'rusti.sh'" \
		&& echo "--- Type './rusti.sh' to start interactive Rust" \
	)

loc:
	clear \
	&& echo "--- Counting lines of .rs files in 'src' (LOC):" \
	&& find src/ -type f -name "*.rs" -exec cat {} \; | wc -l

