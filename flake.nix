{
  description = "LegusX Flake.nix";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # base16.nix
    base16.url = "github:SenchoPens/base16.nix";
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    theme-helix = {
      url = "github:tinted-theming/base16-helix";
      flake = false;
    };
    theme-waybar = {
      url = "github:tinted-theming/base16-waybar";
      flake = false;
    };
    theme-btop = {
      url = "git+https://git.sr.ht/~blueingreen/base16-btop";
      flake = false;
    };
    theme-alacritty = {
      url = "github:aarowill/base16-alacritty";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    disko,
    sops-nix,
    base16,
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
    # Formatter for your nix files, available through 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./shared/nix/overlays {inherit inputs;};

    # NixOS configuration entrypoint
    nixosConfigurations = {
      loganthinkbook = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/loganthinkbook.nix
          ./shared/nix/common.nix
          ./shared/nix/desktop-common.nix
          ./shared/desktops/hyprland/core.nix
          ./shared/nix/vpn.nix
          ./shared/nix/games.nix
          {scheme = ./src/clouds_theme.yaml;}
          sops-nix.nixosModules.sops
          base16.nixosModule
          stylix.nixosModules.stylix
        ];
      };
      beccabook = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/beccabook.nix
          ./shared/nix/common.nix
          ./shared/nix/desktop-common.nix
          ./shared/nix/games.nix
          ./shared/desktops/gnome/core.nix
          ./shared/desktops/hyprland/core.nix
          sops-nix.nixosModules.sops
          base16.nixosModule
        ];
      };
      oraclevps = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/vps/core.nix
          ./shared/nix/common.nix
          ./hosts/vps/mealie.nix
          ./hosts/vps/nextcloud.nix
          {scheme = "${inputs.tt-schemes}/base16/kanagawa.yaml";}
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          base16.nixosModule
        ];
      };
    };
  };
}
