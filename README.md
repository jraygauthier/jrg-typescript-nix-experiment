Readme
======

A personal experiment to evaluate how best to make use of the [nix] package manager's reproducible
environment for [typescript] development.

[nix]: https://nixos.org/guides/how-nix-works.html
[typescript]: https://www.typescriptlang.org/


Maintainer
----------

### Entering the reproducible developer environment

Install the [nix][nix-download] package manager, run `nix-shell` at the root of this
repository:

```bash
$ cd /this/repo/root/dir
$ nix-shell
# ..
```

[nix-download]: https://nixos.org/download.html#download-nix


### Global node packages

See `.nix/node-packages` for the global pinned set of node packages.

Adding a new package to the set should normally be as simple as adding this
package to `.nix/node-packages/node-packages.json` and calling:

```bash
$ ./.nix/node-packages/generate.sh
# ..
```

or alternatively the following convenient make target:

```bash
$ make nix-node-packages
# ..
```

and then, re-enter the reproducible nix environment.


References
----------

 -  [Node.js - NixOS Wiki](https://nixos.wiki/wiki/Node.js)
 -  [NixOS - Nixpkgs 21.11 manual - 15.17. Javascript](https://nixos.org/manual/nixpkgs/stable/#language-javascript)
 -  [Node2nix fails to install with nodejs-15 and nodejs-16 - Issue #236 - svanderburg/node2nix](https://github.com/svanderburg/node2nix/issues/236)
     -  [[WIP] Update nodePackages with node2nix 1.10.0 by svanderburg - Pull Request #146440 - NixOS/nixpkgs](https://github.com/NixOS/nixpkgs/pull/146440)
