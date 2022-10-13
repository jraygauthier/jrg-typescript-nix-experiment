{
  pkgs ? import (import ./default.nix {}).pkgs, # Can be set `null`.
  workspaceDir ? builtins.toString ../..,
} @ args:
import ./default.nix args
