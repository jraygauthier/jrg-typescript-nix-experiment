{ pkgs ? null } @ args:

let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/f77036342e2b690c61c97202bf48f2ce13acc022.tar.gz";
    sha256 = "1vcrb2s6ngfv0vy7nwlqdqhy1whlrck3ws4ifk5dfhmvdy3jqmr4";
  };
  pkgs = if args ? "pkgs"
    then args.pkgs
    else (import nixpkgs { config = {}; });

  # node2nix = localNodePackages.node2nix;

  node2nixSrc = pkgs.fetchFromGitHub {
    owner = "svanderburg";
    repo = "node2nix";
    # <https://github.com/svanderburg/node2nix/releases/tag/node2nix-1.10.0>
    rev = "0deb18a0b62669e62f34cd60286f38f4ac4bf0e8";
    sha256 = "13dqqv53fkzizjzi6ixv0si584s1cvrsyqkcxi7p7rvlziawlsaz";
  };
  node2nix = (import (node2nixSrc + "/release.nix") { inherit nixpkgs; }).package."${pkgs.system}";

  localNodeJs = pkgs.nodejs;
  # TODO: This is still failing even when using node2nix-1.10.0.
  # localNodeJs = pkgs.nodejs-16_x;

  localNodePackages = pkgs.callPackage ./.nix/node-packages { nodejs = localNodeJs; };
  commonShellDeps = with pkgs; [
    gnumake
    localNodeJs
    # node2nix
    # localNodePackages.npm
    # localNodePackages.typescript
    localNodePackages.ts-node
  ];

  lib = import (pkgs.path + "/lib");
  # Involve a pretty long build. Use in last resort and if so,
  # push binaries to a cache.
  # Depends on a `.nvmrc` file with as content, the desired node
  # version (e.g.: `16.13.1`).
  /*
  buildNodeJs = pkgs.callPackage (pkgs.path + "/pkgs/development/web/nodejs/nodejs.nix") {
    python = pkgs.python3;
  };

  nodejsVersion = lib.fileContents ./.nvmrc;
  nodejs = buildNodeJs {
    enableNpm = false;
    version = nodejsVersion;
    sha256 = "1bb3rjb2xxwn6f4grjsa7m1pycp0ad7y6vz7v2d7kbsysx7h08sc";
  };
  */

  # Use a stable version for which hydra can provide binary substitution
  # instead.
  nodejs = pkgs.nodejs-slim-16_x;

  NPM_CONFIG_PREFIX = toString ./npm_config_prefix;

in

with pkgs;

rec {
  inherit nixpkgs;
  inherit pkgs;
  inherit node2nix;

  shell = {
    dev = pkgs.mkShell rec {
      packages = with pkgs; [
      ] ++ commonShellDeps;

      inherit NPM_CONFIG_PREFIX;

      shellHook = ''
        export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
      '';
    };
  };
}
