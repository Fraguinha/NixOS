# Help is available in the configuration.nix(5) man page and in the NixOS
# manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, config, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Include NixOS personal modules.
      ./../../modules/default.nix

      # Include sops-nix.
      inputs.sops-nix.nixosModules.sops
    ];

  # Enable flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Nvidia.
  nvidia.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  # Networking.
  network.enable = true;

  # Enable the GNOME Desktop Environment.
  gnome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable mouse support.
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Define a user accounts.
  users.defaultUserShell = pkgs.zsh;
  users.users.fraguinha = {
    isNormalUser = true;
    description = "João Fraga";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      spotify
      signal-desktop
      neovim
      wezterm
      keepassxc
      syncthing
      gnome.gnome-tweaks
    ];
  };

  # Enable secrets management with sops.
  sops.defaultSopsFile = ./../common/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/fraguinha/.config/sops/age/keys.txt";

  # Secrets
  sops.secrets."keys/id_rsa" = {
    owner = "fraguinha";
    path = "/home/fraguinha/.ssh/id_rsa";
  };
  sops.secrets."keys/id_rsa.pub" = {
    owner = "fraguinha";
    path = "/home/fraguinha/.ssh/id_rsa.pub";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search
  environment.systemPackages = with pkgs; [
    git
    fzf
    ripgrep
    fd
    tree
    hugo
    unzip

    # Programming
    pkg-config
    gnumake
    clang
    rustup
    opam
    python3
    nodejs_21

    # Libraries
    openssl

    # shell
    starship
    zsh-fast-syntax-highlighting
    zsh-autocomplete
    zsh-autopair

    # Security
    sops  # secrets management
    age   # encryption

    # Miscellaneous
    xclip  # for neovim clipboard
  ];

  # List dynamic libraries.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # missing dynamic libraries for programs
    # do not use environment.systemPackages
  ];

  # Program configurations:

  programs.ssh.startAgent = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = ''
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
      source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh

      export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Service configurations:

  services.syncthing = {
    enable = true;
    user = "fraguinha";
    dataDir = "/home/fraguinha/sync";
    configDir = "/home/fraguinha/sync/.config/syncthing";
    overrideDevices = true;  # overrides any devices added or deleted through the WebUI
    overrideFolders = true;  # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "macbook" = { id = "YMAWHKV-JVM2MRR-Q5ELHSD-ZSF2TKS-37WWDHJ-LBKP22A-XU2PE3O-G5MBMAF"; };
        "raspberrypi" = { id = "RGN37UM-FATLQ6Q-GFDQHSB-JZZXWB4-RRESBMP-WAL2SWD-VA7NYU7-C7RHHAX"; };
      };
      folders = {
        "KeePassXC" = {                             # Name of folder in Syncthing, also the folder ID
          path = "/home/fraguinha/sync/KeePassXC";  # Which folder to add to Syncthing
          devices = [ "raspberrypi" "macbook" ];    # Which devices to share the folder with
        };
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
