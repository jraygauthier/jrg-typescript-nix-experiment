{
  pkgs,
  nodejs,
  stdenv,
}: let
  inherit (pkgs) lib;
  super = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  self =
    super
    // {
      # Node package overrides here. See
      # <https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/default.nix>
      # for a couple of examples.
    };
in
  self
