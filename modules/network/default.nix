{ lib, config, ... }:

{
  options.network = {
    enable = lib.mkEnableOption "enable network module";

    hostName = lib.mkOption {
      default = "nixos";
      description = "hostname";
    };

    wireless.enable = lib.mkOption {
      default = false;
      description = "wireless";
    };

    firewall = {
      enable = lib.mkOption {
        default = true;
        description = "firewall";
      };

      allowedTCPPorts = lib.mkOption {
        default = [];
        description = "open TCP ports";
      };

      allowedUDPPorts = lib.mkOption {
        default = [];
        description = "open UDP ports";
      };
    };
  };

  config = lib.mkIf config.network.enable {
    # Networking.
    networking.hostName = config.network.hostName;                # Define your hostname.
    networking.wireless.enable = config.network.wireless.enable;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;

    # Firewall.
    networking.firewall.enable = config.network.firewall.enable;
    networking.firewall.allowedTCPPorts = config.network.firewall.allowedTCPPorts;
    networking.firewall.allowedUDPPorts = config.network.firewall.allowedUDPPorts;
  };
}
