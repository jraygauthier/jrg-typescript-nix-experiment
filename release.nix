{pkgs ? null} @ args: let
  repoRootDir = ./.;
  pkgs =
    (
      import (
        repoRootDir + "/.nix/release.nix"
      ) {}
    )
    .ensurePkgs
    args;

  lib = import (pkgs.path + "/lib");
in

with pkgs;

let
  # Involve a pretty long build. Use in last resort and if so,
  # push binaries to a cache.
  # Depends on a `.nvmrc` file with as content, the desired node
  # version (e.g.: `16.13.1`).
  /*
  buildNodeJs = pkgs.callPackage (pkgs.path + "/pkgs/development/web/nodejs/nodejs.nix") {
    python = python3;
  };

  projectNodejsVersion = lib.fileContents ./.nvmrc;
  projectNodeJs = buildNodeJs {
    enableNpm = false;
    version = projectNodejsVersion;
    sha256 = "1bb3rjb2xxwn6f4grjsa7m1pycp0ad7y6vz7v2d7kbsysx7h08sc";
  };
  */

  # Use a stable version for which hydra can provide binary substitution
  # instead.
  # projectNodeJs = nodejs-14_x;

  # TODO: This is still failing.
  # projectNodeJs = nodejs;
  # TODO: This is still failing even when using node2nix-1.10.0.
  projectNodeJs = nodejs-16_x;

  projectNodePackages = callPackage ./.nix/node2nix { nodejs = projectNodeJs; };
  commonShellDeps = [
    coreutils
    gnumake
    projectNodeJs
    projectNodePackages.npm
    projectNodePackages.typescript
    projectNodePackages.ts-node
  ];

  NPM_CONFIG_PREFIX = toString ./.npm;

in

rec {
  shell = {
    dev = mkShell rec {
      packages = [
      ] ++ commonShellDeps;

      inherit NPM_CONFIG_PREFIX;

      shellHook = ''
        # Add local node and npm globally built packages to PATH.
        export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
      '';
    };
  };
}
