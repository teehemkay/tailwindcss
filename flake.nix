{
  description = "frontend standard development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default-darwin";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Override flake-utils systems to mine
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = { self, nixpkgs, systems, flake-utils, rust-overlay, ... }:
    let
      eachSystem = f:
        flake-utils.lib.eachSystem (import systems) (system:
          f (import nixpkgs {
            inherit system;
            overlays = [ rust-overlay.overlays.default ];
          }));

    in eachSystem (pkgs:
      let
        inherit (pkgs) stdenv lib mkShell;
        inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation CoreServices;

        rustToolchain =
          pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in {
        devShells = {
          default = mkShell {
            packages = [
              pkgs.astro-language-server
              pkgs.html-tidy
              pkgs.marksman
              pkgs.nodejs
              pkgs.pnpm_9
              pkgs.tailwindcss-language-server
              pkgs.typescript
              pkgs.typescript-language-server
              pkgs.vscode-langservers-extracted
              pkgs.yaml-language-server
              rustToolchain
            ] ++ lib.optionals stdenv.isDarwin [ CoreFoundation CoreServices ];
          };
        };
      });
}
