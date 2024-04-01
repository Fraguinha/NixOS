{
  description = "fraguinha's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations =
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/desktop/configuration.nix ];
      };
    };
  };
}
