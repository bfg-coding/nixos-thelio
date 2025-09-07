# modules/storage/default.nix
# Storage, mounting, and filesystem configuration

{ config, lib, pkgs, ... }:

{
  # Auto-mounting and file system support
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # File system support for various drive formats
  boot.supportedFilesystems = [
    "ntfs" # Windows drives
    "exfat" # Cross-platform drives  
    "ext4" # Linux drives
    "btrfs" # Modern Linux filesystem
    "xfs" # Enterprise Linux filesystem
  ];

  # Storage-related packages
  environment.systemPackages = with pkgs; [
    # Drive management tools
    udisks
    udiskie
    lsof

    # File system utilities
    ntfs3g
    exfat
    dosfstools
  ];

  # DevStorage drive configuration
  # Update the UUID below to match your drive: sudo blkid /dev/sda1
  systemd.mounts = [{
    description = "DevStorage - External Drive";
    what = "/dev/disk/by-uuid/BD23-A737"; # Update this UUID!
    where = "/run/media/justin/DevStorage";
    type = "exfat"; # Change if your drive uses different filesystem
    options = "defaults,nofail,uid=1000,gid=100,umask=022,iocharset=utf8";

    unitConfig = {
      RequiresMountsFor = "/run/media/justin";
    };
  }];

  # Auto-mount configuration
  systemd.automounts = [{
    description = "DevStorage Auto-mount";
    where = "/run/media/justin/DevStorage";
    wantedBy = [ "multi-user.target" ];

    automountConfig = {
      TimeoutIdleSec = "300"; # Unmount after 5 minutes of inactivity
      DirectoryMode = "0755";
    };
  }];

  # Ensure mount directory exists
  systemd.tmpfiles.rules = [
    "d /run/media/justin 0755 justin users -"
    "d /run/media/justin/DevStorage 0755 justin users -"
  ];
}
