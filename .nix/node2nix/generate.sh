#!/usr/bin/env bash
set -eu -o pipefail
declare script_dir
script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

declare node2nix
node2nix="$(nix-build -E '(import ../release.nix {}).pkgs.node2nix')"
on_exit() {
  test ! -e "$script_dir/result" || unlink "$script_dir/result"
}
trap "on_exit" EXIT SIGINT SIGQUIT

rm -f ./node-env.nix

declare pkg_name="global-node-packages"

declare extra_args=()
declare extra_args=( "--nodejs-16" )

"${node2nix}/bin/node2nix" \
    -i ./node-packages.json \
    --output ./node-packages.nix \
    --composition ./composition.nix \
    --node-env ./node-env.nix \
    --pkg-name "$pkg_name" \
    "${extra_args[@]}"

