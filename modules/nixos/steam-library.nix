{
  config,
  pkgs,
  lib,
  ...
}: let
  bind = source: target: {
    device = source;
    mountPoint = target;
    fsType = "fuse.bindfs";
  };
in {
  options = {
    services.steamlibrary = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable steam library mounts";
      };

      mounts = lib.mkOption {
        type = with lib.types; list (attrsOf str);
        description = "List of library mounts with source and target directories.";
        example = [
          {
            source = "/source/path1";
            name = "Steam 1";
          }
          {
            source = "/source/path2";
            name = "Steam 2";
          }
        ];
      };

      root = lib.mkOption {
        type = lib.types.path;
        description = "The root directory to link all the libraries into";
        example = /opt/steam;
      };
    };
  };

  assertions = [
    {
      assertion = config.services.steamlibrary.enable && lib.length config.services.steamlibrary.mounts == 0;
      message = "You must define at least one mount for steamlibrary to do anything.";
    }
    {
      assertion = config.services.steamlibrary.enable && config.services.steamlibrary.root == undefined;
      message = "You must define a root directory to link your libraries to.";
    }
  ];

  config = let
    indexedMounts = lib.genList (n: {
      index = n;
      source = mounts.${n}.source;
      target = mounts.${n}.target;
      name = mounts.${n}.name;
    }) (lib.length mounts);
  in
    lib.mkIf config.services.steamlibrary.enable {
      systemd.tmpfiles.rules = [
        "d ${config.services.steamlibrary.root} 0777 root root 0 -"
        +
        map (mount: {
          "d ${config.services.steamlibrary.root}/${mount.name} 0777 root root 0 -"
        }) indexedMounts
      ];
      fileSystems = lib.listToAttrs (map (mount: {
        name = "${config.services.steamlibrary.root}/${mount.name}";l
        value = {
          label =
            ${
              if mount.name == undefined
              then "Steam Library " + mount.index
              else mount.name
            };
          device =
            ${
              if mount.source == undefined
              then throw "steamlibrary.mounts.<mountname>.source must be defined!"
              else mount.source
            };
          fsType = "fuse.bindfs";
          options = ["mirror" "perms=777" "x-gvfs-show"];
        };
      }));
    };
}
