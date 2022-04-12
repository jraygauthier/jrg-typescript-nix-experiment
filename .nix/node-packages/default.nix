{ pkgs, nodejs, stdenv }:

let
  inherit (pkgs) lib;
  super = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  self = super // {
    # Node package overrides here. See
    # <https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/default.nix>
    # for a couple of examples.
    ts-node = super.ts-node.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/ts-node" \
        --prefix NODE_PATH : ${self.typescript}/lib/node_modules
      '';
    });
  };
in self
