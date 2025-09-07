# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.nvidia-jetpack.enable = true;
  hardware.nvidia-jetpack.som = "orin-agx";
  hardware.nvidia-jetpack.carrierBoard = "devkit";

  hardware.graphics.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Adding flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable network manager
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pookie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    ripgrep
    lazygit
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Enable tailscale
  services.tailscale.enable = true;

  # DO NOT CHANGE
  system.stateVersion = "25.05";
}
