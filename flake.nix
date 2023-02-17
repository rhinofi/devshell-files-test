{
  description = "virtual environments";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.dsf.url = "github:rhinofi/devshell-files/rhinofi/expose-single-devshell-independent-command-for-creating-all-files";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, devshell, dsf, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };
        configuration = {
          imports = [
            (dsf + "/modules/files.nix")
            (dsf + "/modules/text.nix")
            (dsf + "/modules/git.nix")
          ];
          file."/README.md".text = ''# Hello there'';
        };
        devshellEvalled = pkgs.devshell.eval { inherit configuration; };
      in rec {
        defaultPackage = devshellEvalled.config.files.create-all;
      }
    );
}
