{ lib, config, ... }:

{
  options.x11 = {
    enable = lib.mkEnableOption "enable x11 module";
  };

  config = lib.mkIf config.gnome.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11.
    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
    };
  };
}
