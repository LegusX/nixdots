{
  description = "LegusX Flake.nix";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixos-cosmic/nixpkgs-stable";

    # Stylix
    stylix.url = "github:danth/stylix/release-24.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";

    # Hyprland
    # hyprland.url = "github:hyprwm/Hyprland/927e1b5a8f7f5842c761abc084d22fdc33fbec18";
    hyprland.url = "github:hyprwm/Hyprland/9a3bec5d0aae80aaa49a5f8822d983107123196a";
    # hyprland.url = "github:hyprwm/Hyprland/0bd541f2fd902dbfa04c3ea2ccf679395e316887";
    # hyprland.url = "github:hyprwm/Hyprland/12f9a0d0b93f691d4d9923716557154d74777b0a";

    # base16.nix
    base16.url = "github:SenchoPens/base16.nix";
    theme-helix = {
      url = "github:tinted-theming/base16-helix";
      flake = false;
    };
    theme-waybar = {
      url = "github:tinted-theming/base16-waybar";
      flake = false;
    };
    theme-alacritty = {
      url = "github:aarowill/base16-alacritty";
      flake = false;
    };

    # Cachy Kernel
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    #flatpak nix
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.5.2";

    # Walker
    walker.url = "github:abenz1267/walker";

    # Winapps
    winapps.url = "github:winapps-org/winapps";
    winapps.inputs.nixpkgs.follows = "nixpkgs";

    # gauntlet
    gauntlet.url = github:project-gauntlet/gauntlet/704b466b209903970e32b40a94334723b88c36ea;
    gauntlet.inputs.nixpkgs.follows = "nixpkgs";

    #cosmic
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs-stable";
    nixpkgs-unstable.follows = "nixos-cosmic/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    disko,
    sops-nix,
    base16,
    hyprland,
    chaotic,
    nix-flatpak,
    walker,
    winapps,
    gauntlet,
    nixos-cosmic,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./modules/overlays.nix {inherit inputs;};

    # NixOS configuration entrypoint
    nixosConfigurations = {
      loganthinkbook = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/loganthinkbook.nix
          {scheme = ./src/clouds_theme.yaml;}
          sops-nix.nixosModules.sops
          base16.nixosModule
          stylix.nixosModules.stylix
          disko.nixosModules.disko
          # gauntlet.nixosModules.default
        ];
      };
      ryzenshine = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/ryzenshine.nix
          {scheme = ./src/clouds_theme.yaml;}
          sops-nix.nixosModules.sops
          base16.nixosModule
          stylix.nixosModules.stylix
          disko.nixosModules.disko
          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry
          nix-flatpak.nixosModules.nix-flatpak
          nixos-cosmic.nixosModules.default
          # gauntlet.nixosModules.default
        ];
      };
      beccabook = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/beccabook.nix
          sops-nix.nixosModules.sops
          base16.nixosModule
          stylix.nixosModules.stylix
        ];
      };
      oraclevps = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/vps/core.nix
          # {scheme = ./src/clouds_theme.yaml;}
          sops-nix.nixosModules.sops
          # base16.nixosModule
          disko.nixosModules.disko
          # stylix.nixosModules.stylix
        ];
      };
    };
  };
}
