{
  description = "Nix Flake for my personal website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-darwin"];
    eachSystem = f:
      nixpkgs.lib.genAttrs systems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = eachSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # hugo static website engine
          hugo

          # hugo's dependencies
          go
        ];
      };
    });
  };
}
