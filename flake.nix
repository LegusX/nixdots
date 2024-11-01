{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix
    stylix.url = "github:danth/stylix/release-24.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    disko,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available thxxrough 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./shared/nix/overlays {inherit inputs;};

    # NixOS configuration entrypoint
    nixosConfigurations = {
      loganthinkbook = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hosts/loganthinkbook.nix
          ./nixos/common.nix
          ./nixos/desktop-common.nix
          ./nixos/hyprland.nix
          ./nixos/vpn.nix
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops
        ];
      };
      beccabook = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hosts/beccabook.nix
          ./nixos/common.nix
          ./nixos/desktop-common.nix
          #./nixos/games.nix
          ./nixos/gnome.nix
          ./nixos/hyprland.nix
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops
        ];
      };
      oraclevps = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hosts/vps.nix
          ./nixos/common.nix
          ./nixos/services/mealie.nix
          ./nixos/services/nextcloud.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
