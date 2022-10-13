.PHONY: \
  all \
  clean \
  clean-build \
  build \
  run-only \
  run \
  node2nix




all: \
  build

clean: \
  clean-build

build:
	tsc index.ts

clean-build:
	rm -f ./index.js

run-only:
	node index.js

run:
	ts-node index.ts

node2nix:
	./.nix/node2nix/generate.sh
