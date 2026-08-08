{
  pkgs,
  utils,
  ...
}:
{
  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];

    files = [
      "/etc/machine-id"
    ];
  };
  boot.initrd.systemd.services.root-reset = {
    description = "Rotate ephemeral Btrfs root";

    unitConfig.DefaultDependencies = false;

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    requiredBy = [ "initrd.target" ];

    before = [ "sysroot.mount" ];

    requires = [
      "${utils.escapeSystemdPath "/dev/nyx/root"}.device"
    ];

    after = [
      "${utils.escapeSystemdPath "/dev/nyx/root"}.device"

      # Let hibernation resume before touching the root filesystem.
      "local-fs-pre.target"
    ];

    path = [
      pkgs.btrfs-progs
      pkgs.coreutils
      pkgs.util-linux
    ];

    script = ''
      set -eu

      mountpoint=/btrfs_tmp
      device=/dev/nyx/root

      mkdir -p "$mountpoint"

      # Mount Btrfs' top-level subvolume, not the current root subvolume.
      mount -t btrfs -o subvolid=5 "$device" "$mountpoint"

      # Always try to unmount if something below fails.
      trap 'umount "$mountpoint"' EXIT

      if [ -e "$mountpoint/root" ]; then
        mkdir -p "$mountpoint/old_roots"

        timestamp="$(
          date \
            --date="@$(stat -c %Y "$mountpoint/root")" \
            "+%Y-%m-%d_%H-%M-%S"
        )"

        mv \
          "$mountpoint/root" \
          "$mountpoint/old_roots/$timestamp"
      fi

      # Delete roots older than seven days.
      cutoff="$(( $(date +%s) - 7 * 24 * 60 * 60 ))"

      for old_root in "$mountpoint"/old_roots/*; do
        [ -e "$old_root" ] || continue

        modified="$(stat -c %Y "$old_root")"

        if [ "$modified" -lt "$cutoff" ]; then
          btrfs subvolume delete --recursive "$old_root"
        fi
      done

      btrfs subvolume create "$mountpoint/root"
    '';
  };
}
