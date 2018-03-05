all: setup build install

dev:
	@stack build --fast --test --file-watch

run:
	@stack exec git-list

setup:
	@stack setup

clean:
	@stack clean
	rm -rf .stack-work git-list.cabal

build:
	@stack build -j4 --ghc-options -O2

install:
	@stack install git-list

force:

.PHONY: force
