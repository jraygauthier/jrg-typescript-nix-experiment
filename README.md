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

See `.nix/node2nix` for the global pinned set of node packages.

Adding a new package to the set should normally be as simple as adding this
package to `.nix/node2nix/node2nix.json` and calling:

```bash
$ make node2nix
# ..
```

and then, re-enter the reproducible nix environment.


### Project initialization

Here's what was done to initialize this typescript project:

```bash
$ npm init -y
# -> 'package.json'
```

```bash
$ npm install axios@1.1.0
# -> 'package.json'
# -> 'package-lock.json'
# -> 'node_modules'
```

### Building the application

```bash
$ make
# ..

# Or more specifically:
$ make build
# ..
```


### Running the application

```bash
$ make run-only
# ..
```


### Build and run the application

```bash
$ make run
# ..
```


References
----------

 -  [Node.js - NixOS Wiki](https://nixos.wiki/wiki/Node.js)
 -  [NixOS - Nixpkgs 21.11 manual - 15.17. Javascript](https://nixos.org/manual/nixpkgs/stable/#language-javascript)
 -  [Node2nix fails to install with nodejs-15 and nodejs-16 - Issue #236 - svanderburg/node2nix](https://github.com/svanderburg/node2nix/issues/236)

     -  [Emit lockfile v2 and fix bin links with NPM v7+ by lilyinstarlight · Pull Request #302 · svanderburg/node2nix](https://github.com/svanderburg/node2nix/pull/302)

 -  [[1.0.0] TypeError: Cannot read properties of undefined (reading 'create') · Issue #5011 · axios/axios](https://github.com/axios/axios/issues/5011)

 -  [Typescript: The Complete Developer's Guide | Udemy](https://www.udemy.com/course/typescript-the-complete-developers-guide/)
