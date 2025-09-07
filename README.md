# NixOS Configuration for NVIDIA Jetson AGX Orin

This repository contains a NixOS configuration specifically tailored for the NVIDIA Jetson AGX Orin development kit. The configuration leverages Nix flakes for reproducible builds and includes hardware-specific optimizations for the Jetson platform.

## Overview

This setup provides a minimal yet functional NixOS environment on the Jetson AGX Orin with essential development tools and services. The configuration is designed for headless operation with remote access capabilities.

## Prerequisites

- NVIDIA Jetson AGX Orin Developer Kit
- NixOS installation media compatible with ARM64 architecture
- (Follow this repository created by -> [anduril](https://github.com/anduril/jetpack-nixos))
- Basic familiarity with NixOS configuration management
- Network connectivity for package downloads during installation

## Configuration Features

### Hardware Support

- **NVIDIA Jetpack Integration**: Full hardware acceleration support through the jetpack-nixos module
- **Graphics Acceleration**: Enabled hardware graphics support for GPU-accelerated workloads
- **System-on-Module**: Configured for Orin AGX SoM with development kit carrier board

### System Services

- **SSH Access**: OpenSSH daemon enabled for remote administration
- **Tailscale VPN**: Zero-config VPN service for secure remote access
- **Network Management**: NetworkManager for simplified network configuration

### Development Environment

- **Text Editor**: Neovim with syntax highlighting and plugin support
- **Version Control**: Git with lazygit for improved workflow
- **System Utilities**: Essential tools including wget, ripgrep, and tree

## File Structure

```
.
├── flake.nix              # Nix flake definition with inputs and outputs
├── configuration.nix      # Main system configuration
├── hardware-configuration.nix  # Auto-generated hardware configuration
└── README.md             # This documentation
```

## Installation

### 1. Initial System Setup

Boot from NixOS installation media and partition your storage device according to your requirements. The configuration assumes an EFI-compatible setup.

### 2. Clone Configuration

```bash
git clone https://github.com/Eik-Lab/jetson-nixos-config.git /mnt/etc/nixos
cd /mnt/etc/nixos
```

### 3. Generate Hardware Configuration

```bash
nixos-generate-config --root /mnt
```

Replace the generated `configuration.nix` with the provided configuration, but preserve any hardware-specific settings from your generated `hardware-configuration.nix`.

### 4. Install NixOS

```bash
nixos-install --flake .#nixos
```

### 5. Post-Installation

After rebooting into the new system:

```bash
# Set password for the pookie user
passwd pookie

# Update the system
sudo nixos-rebuild switch --flake .#nixos
```

## Configuration Details

### Flake Configuration

The `flake.nix` defines:

- **nixpkgs**: Pinned to NixOS 25.05 for stability
- **jetpack**: Anduril's jetpack-nixos module for Jetson hardware support
- **System Configuration**: Single host configuration named "nixos"

### System Configuration

Key configuration elements in `configuration.nix`:

#### Hardware Optimization

```nix
hardware.nvidia-jetpack.enable = true;
hardware.nvidia-jetpack.som = "orin-agx";
hardware.nvidia-jetpack.carrierBoard = "devkit";
hardware.graphics.enable = true;
```

#### User Management

- Default user: `pookie`
- Sudo access enabled via wheel group
- Minimal package set for development workflow

#### Network Configuration

- Hostname: `nixos` (customize as needed)
- NetworkManager for connection management
- Tailscale for VPN connectivity

## Customization

### Adding Packages

To add system-wide packages, modify the `environment.systemPackages` list in `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  # Existing packages
  neovim
  wget
  git
  ripgrep
  lazygit

  # Add your packages here
  htop
  tmux
  python3
];
```

### User-Specific Packages

Add packages for the user in the `users.users.pookie.packages` section:

```nix
users.users.pookie = {
  isNormalUser = true;
  extraGroups = [ "wheel" ];
  packages = with pkgs; [
    tree
    # Add user-specific packages here
  ];
};
```

### Enabling Additional Services

Common services can be enabled by adding configuration blocks:

```nix
# Enable Docker
virtualisation.docker.enable = true;

# Enable development services
services.postgresql.enable = true;
```

## Maintenance

### System Updates

```bash
# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#nixos
```

### Garbage Collection

```bash
# Clean old generations
sudo nix-collect-garbage -d

# Clean user profile
nix-collect-garbage -d
```

## Troubleshooting

### Common Issues

1. **Boot Issues**: Ensure EFI variables are accessible and systemd-boot is properly configured
2. **Hardware Acceleration**: Verify jetpack module is loading correctly with `lsmod | grep nvidia`
3. **Network Connectivity**: Check NetworkManager status with `systemctl status NetworkManager`

### Logs and Diagnostics

```bash
# System logs
journalctl -xe

# Hardware information
lshw -short

# GPU status
nvidia-smi
```

## Contributing

When modifying this configuration:

1. Test changes in a virtual machine when possible
2. Document any hardware-specific requirements
3. Follow NixOS configuration best practices
4. Update this README for significant changes

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Jetpack NixOS Documentation](https://github.com/anduril/jetpack-nixos)
- [NVIDIA Jetson Developer Resources](https://developer.nvidia.com/embedded/jetson-agx-orin-developer-kit)
- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)

## License

This configuration is provided as-is for educational and development purposes. Please review and adapt according to your specific requirements and security policies.
