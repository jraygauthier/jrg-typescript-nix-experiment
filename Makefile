.PHONY: \
  all \
  clean \
  nix-node-packages



all:

clean:


nix-node-packages:
	./.nix/node-packages/generate.sh
