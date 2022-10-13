#
# The minimal dependencies required to run utility scripts in
# this (`nix`) directory.
#
{
  pkgs ? null,
  workspaceDir ? null,
} @ args: let
  nixpkgsSrc = builtins.fetchTarball {
    # nixos-22.05 at 24/08/2022
    url = "https://github.com/nixos/nixpkgs/archive/b9fd420fa535fd254c6f1f26df770b32a9dc98b4.tar.gz";
    sha256 = "18kchwzxi5q9v9h6jwlaxgsx1351grfd3ij2d4103lc1vlsmfqg3";
  };
  nixpkgs = nixpkgsSrc;

  # None at this time.
  srcs = {};
  pickedSrcs = {};

  # This repo's internal overlay.
  overlayInternal = import ./overlay-internal.nix {inherit srcs pickedSrcs;};
  overlayInternalReqs = builtins.attrNames (overlayInternal {} {});

  hasOverlayInternal = pkgs:
    builtins.all (x: x) (
      builtins.map (
        x: builtins.hasAttr x pkgs
      )
      overlayInternalReqs
    );

  # The set of overlays used by this repo.
  overlays = [
    overlayInternal
  ];

  defaultPkgsConfig = {
  };

  importPkgs = {nixpkgs ? null} @ args: let
    nixpkgs =
      if args ? "nixpkgs" && null != args.nixpkgs
      then args.nixpkgs
      else nixpkgsSrc; # From top level.
  in
    assert null != nixpkgs;
      import nixpkgs {
        inherit overlays;
        config = defaultPkgsConfig;
      };

  ensurePkgs = {
    pkgs ? null,
    nixpkgs ? null,
  }:
    if null != pkgs
    then
      if hasOverlayInternal pkgs
      # Avoid extending a `pkgs` that already has our overlays.
      then pkgs
      else pkgs.appendOverlays overlays
    else importPkgs {inherit nixpkgs;};

  pkgs = ensurePkgs args;
in
  with pkgs; {
    inherit pkgs nixpkgs ensurePkgs;
  }
