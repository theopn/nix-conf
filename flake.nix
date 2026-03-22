{
  description = "Theo's Nix Flake for NixOS (Framework 13), nix-darwin (M4 Mac Mini), and home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-darwin, home-manager, nixvim, ... }:
  {
    darwinConfigurations.beauvoir = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/beauvoir/configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.users.theopn = {
            imports =[
              nixvim.homeModules.nixvim
              ./home-manager/home.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.wittgenstein = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        ./hosts/wittgenstein/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.users.theopn = {
            imports =[
              nixvim.homeModules.nixvim
              ./home-manager/home.nix
              ./home-manager/linux.nix
            ];
          };
        }
      ];
    };
  };
}
