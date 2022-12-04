VERSION   := $(shell git describe --dirty --tags --match 'v[0-9][.]*' | sed -e s/^v// -e s/-g/-/)
GIT_DIR   := $(shell git rev-parse --git-dir)
HEADS     := $(GIT_DIR)/HEAD $(shell git show-ref --heads --tags | sed -e 's,.* ,$(GIT_DIR)/,')

default: test run

run: test

version: Cargo.toml

Cargo.toml: input.toml Makefile $(HEADS)
	@ echo making $@ using $< as input
	@ (flock -x 9; chmod -c 0600 $@; \
       (echo '# THIS FILE IS GENERATED #'; \
        sed -e 's/^#.*//' -e 's/UNKNOWN/$(VERSION)/' $<; \
        echo '# THIS FILE IS GENERATED #') \
			| grep . > $@ \
				&& grep -H ^version $@; \
	  chmod -c 0444 $@) 9>/tmp/cargo.lockfile

doc run test build: Cargo.toml
	cargo $@ --color=always

clippy lint: Cargo.toml
	cargo clippy

auto-lint: Cargo.toml
	cargo clippy --allow-dirty --fix

%-help: Cargo.toml
	cargo run --bin $* -- --help

update: Cargo.toml
	cargo update
	sed -e s/$(VERSION)/UNKNOWN/ $< | grep -v GENERATED > input.toml

ubuild:
	@+make --no-print-directory update
	@+make --no-print-directory build

clean:
	cargo $@
	git clean -dfx

release:
	cargo build --release

target/debug/%: src/%.rs src/lib.rs Cargo.toml
	cargo build --bin $*

target/release/%: src/%.rs src/lib.rs Cargo.toml
	cargo build --bin $* --release

install: /usr/bin/rknock /usr/bin/rk_door

watch-run: last-action
	gh run watch $$(< .last-action)

workflow-run-% run-workflow-% actions-% action-%: .github/workflows/%.yaml
	gh workflow run $*
	@echo wait around for 5 seconds
	@+make --no-print-directory watch-run
