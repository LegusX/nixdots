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
        type = with lib.types; list (attrsOf str);
        description = "List of library mounts with source and target directories.";
        default = [
          {
            source = "/opt/steam/library";
            dirName = "library";
            label = "Steam Library";
          }
        ];
      };

      root = lib.mkOption {
        type = lib.types.path;
        description = "The root directory to link all the libraries into";
        example = /opt/steam;
        default = /opt/steam;
      };
    };
  };

  assertions = [
    # {
    #   assertion = config.services.steamlibrary.enable && lib.length config.services.steamlibrary.mounts == 0;
    #   message = "You must define at least one mount for steamlibrary to do anything.";
    # }
    # {
    #   assertion = config.services.steamlibrary.enable && config.services.steamlibrary.root == undefined;
    #   message = "You must define a root directory to link your libraries to.";
    # }
  ];

  # config = let
  #   # Index the mounts in case the user doesn't supply names for the mounts
  #   mounts = config.services.steamlibrary.mounts;
  #   indexedMounts = lib.genList (n: {
  #     index = n;
  #     source = mounts.${n}.source;
  #     label = mounts.${n}.label;
  #     dir = mounts.${n}.dirName;
  #   }) (lib.length mounts);
  # in
  #   lib.mkIf config.services.steamlibrary.enable {
  #     system.fsPackages = [
  #       pkgs.bindfs
  #     ];
  #     systemd.tmpfiles.rules =
  #       map (
  #         mount: "d ${config.services.steamlibrary.root}/${mount.dir} 0777 root root 0 -"
  #       )
  #       indexedMounts;
  #     fileSystems = lib.listToAttrs (map (mount: {
  #       name = "${config.services.steamlibrary.root}/${mount.name}";
  #       value = {
  #         label = mount.label;
  #         device =
  #           if mount.source == null
  #           then throw "steamlibrary.mounts.<mountname>.source must be defined!"
  #           else mount.source;
  #         fsType = "fuse.bindfs";
  #         options = ["mirror" "perms=777" "x-gvfs-show" "nofail"];
  #       };
  #     }));
  #   };
}
