
dev:
	@stack build --fast --test --file-watch

run:
	@stack exec git-list

build:
	@stack build -j4 --copy-bins --ghc-options -O2
	@stack install git-list

force:

.PHONY: force
