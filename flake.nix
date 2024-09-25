{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      perSystem = {pkgs, ...}: let
        python-env = pkgs.python3.withPackages (ps: [
          ps.ansible-core
          ps.pytest
          ps.pytest-ansible
        ]);
        shell = pkgs.mkShell {
          packages = with pkgs; [
            python-env
          ];
        };
      in {
        devShells.default = shell;
      };
    };
}
