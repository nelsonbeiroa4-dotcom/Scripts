{ config, lib, pkgs, ... }:
{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "ShadowOS";
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false;
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";
  console.keyMap = "es";
  services.xserver.enable = true;
  services.xserver.xkb.layout = "es";
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.greetd.enable = true;
  services.greetd.settings.default_session = {
    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
    user = "greeter";
  };
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;
  users.users.nixos = {
    isNormalUser = true;
    description = "ShadowOS Live User";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "storage" ];
    initialPassword = "nixos";
  };
  users.users.nixos.shell = pkgs.fish;
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    firefox kitty thunar file-roller
    waybar wofi swaynotificationcenter
    hyprpaper hyprlock hypridle
    networkmanagerapplet blueman pavucontrol
    brightnessctl playerctl pamixer
    btop fastfetch git curl wget
    wl-clipboard grim slurp
    polkit_gnome xdg-utils xdg-user-dirs
    papirus-icon-theme bibata-cursors
    adwaita-icon-theme
    noto-fonts noto-fonts-emoji
    inter jetbrains-mono
    gnome-disk-utility
  ];
  fonts.packages = with pkgs; [ inter jetbrains-mono noto-fonts noto-fonts-emoji ];
  environment.etc."xdg/waybar/config".text = builtins.toJSON {
    layer = "top"; position = "top"; height = 38;
    modules-left = [ "hyprland/workspaces" "hyprland/window" ];
    modules-center = [ "clock" ];
    modules-right = [ "network" "bluetooth" "pulseaudio" "memory" "cpu" "battery" "tray" ];
    clock = { format = "{:%A, %d %B  ·  %H:%M}"; };
    network = { format-wifi = "  {essid}"; format-ethernet = "󰈀  Connected"; format-disconnected = "󰖪  Offline"; };
    bluetooth = { format = " {status}"; };
    pulseaudio = { format = "󰕾 {volume}%"; };
    memory = { format = "󰍛 {percentage}%"; };
    cpu = { format = "󰻠 {usage}%"; };
    battery = { format = "{capacity}%"; };
    tray = { spacing = 10; };
  };
  environment.etc."xdg/hypr/hyprland.conf".text = ''
    monitor = ,preferred,auto,1
    $mod = SUPER
    exec-once = waybar
    exec-once = swaync
    exec-once = nm-applet --indicator
    exec-once = blueman-applet
    exec-once = hyprpaper
    input { kb_layout = es }
    general { gaps_in = 5 gaps_out = 12 border_size = 2 }
    decoration { rounding = 14 active_opacity = 0.96 inactive_opacity = 0.90 blur { enabled = yes size = 6 passes = 2 } }
    animations { enabled = yes }
    dwindle { pseudotile = yes preserve_split = yes }
    "$mod, RETURN, exec, kitty"
    "$mod, E, exec, thunar"
    "$mod, D, exec, wofi --show drun"
    "$mod, Q, killactive"
    "$mod, F, fullscreen"
    "$mod, V, togglefloating"
    "$mod, M, exit"
  '';
  system.stateVersion = "25.11";
  isoImage.isoName = "ShadowOS-x86_64.iso";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.volumeID = "SHADOWOS";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}