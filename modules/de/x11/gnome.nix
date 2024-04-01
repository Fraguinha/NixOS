{ lib, config, ... }:

{
  imports = [
    ./x11.nix
  ];

  options.gnome = {
    enable = lib.mkEnableOption "enable gnome module";
  };

  config = lib.mkIf config.gnome.enable {
    # Enable x11
    x11.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = false;
    };
    services.xserver.desktopManager.gnome.enable = true;
  };
}
