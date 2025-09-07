{
  description = "NixOS and Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    crystalnix = {
      url = "path:/home/justin/Repo/bfg/crystalnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, zen-browser, crystalnix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "justin";
    in
    {
      nixosConfigurations = {
        nixos-thelio = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs;
                  unstable = import nixpkgs-unstable {
                    system = "x86_64-linux";
                    config.allowUnfree = false;
                  };
                  # Convert hex colors to rgba format for Hyprland
                  stylesheet = inputs.crystalnix.lib.mkStylesheet { theme = "tokyonight"; };
                };
                users.${username} = import ./home.nix;
              };
            }
          ];
        };
      };
    };
}
