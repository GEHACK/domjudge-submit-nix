{
  description = "DOMjudge submit CLI, packaged for Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      domjudge-submit = pkgs.callPackage ./pkg.nix { };
    in
    {
      overlays.default = final: _prev: {
        domjudge-submit = final.callPackage ./pkg.nix { };
      };

      packages.x86_64-linux = {
        inherit domjudge-submit;
        default = domjudge-submit;
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          jq
        ];
      };
    };
}
