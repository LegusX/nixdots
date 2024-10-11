{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    services.steamlibrary = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable steam library mounts";
      };

      mounts = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.str);
        description = "List of library mounts with source and target directories.";
        default = [
          {
            source = "/opt/steam/library";
            dirName = "library";
            label = "Steam Library";
          }
        ];
      };

      # root = lib.mkOption {
      #   type = lib.types.path;
      #   description = "The root directory to link all the libraries into";
      #   example = /opt/steam;
      #   default = /opt/steam;
      # };
    };
  };

  # assertions = [
  # {
  #   assertion = config.services.steamlibrary.enable && lib.length config.services.steamlibrary.mounts == 0;
  #   message = "You must define at least one mount for steamlibrary to do anything.";
  # }
  # {
  #   assertion = config.services.steamlibrary.enable && config.services.steamlibrary.root == undefined;
  #   message = "You must define a root directory to link your libraries to.";
  # }
  # ];

  config = let
    # Index the mounts in case the user doesn't supply names for the mounts
    root = "/opt/steam";
    mounts = config.services.steamlibrary.mounts;
    indexedMounts = lib.genList (n: {
      index = n;
      source = mounts.${n}.source;
      label = mounts.${n}.label;
      dir = mounts.${n}.dirName;
    }) (lib.length mounts);
    users = lib.strings.concatStringsSep ":" (lib.filter (name:
    lib.hasAttr "home" config.users.users.${name} && config.users.users.${name}.home != null
  ) (builtins.attrNames config.users.users));
  in
    lib.mkIf config.services.steamlibrary.enable {
      system.fsPackages = [
        pkgs.bindfs
      ];
      systemd.tmpfiles.rules = 
        map (
            mount: "d ${root}/${mount.dirName} 0777 root root -"
          )
          config.services.steamlibrary.mounts;
      fileSystems = lib.listToAttrs (map (mount: {
        name = "${root}/${mount.dirName}";
        value = {
          label = mount.label;
          device =
            if mount.source == null
            then throw "steamlibrary.mounts.<mountname>.source must be defined!"
            else mount.source;
          fsType = "fuse.bindfs";
          options = ["perms=0777:+X" "mirror=${users}" "x-gvfs-show" "nofail"];
        };
      }) mounts);
    };
}
