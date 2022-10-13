{
  srcs,
  pickedSrcs,
}: self: super:
let
  node2nixSrc = super.fetchFromGitHub {
    owner = "svanderburg";
    repo = "node2nix";
    # 2022/09/28 npm v7 support.
    # <https://github.com/svanderburg/node2nix/commit/a6041f67b8d4a300c6f8d097289fe5addbc5edf8>
    rev = "a6041f67b8d4a300c6f8d097289fe5addbc5edf8";
    sha256 = "sha256-361KP3ys806YgwVIeXw6CrQmdV2ldJ3u95rcZUbI5vY=";
  };
in
{
  node2nix = (import (node2nixSrc + "/release.nix") { nixpkgs = super.path; }).package."${super.system}";
}
