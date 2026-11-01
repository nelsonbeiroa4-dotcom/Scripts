{
  description = "ShadowOS - bootable NixOS image with DarkShadow's Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    shadows-shell = {
      url = "github:shadowww-dev/shadows-shell";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, shadows-shell }: {
    nixosConfigurations.shadowos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit shadows-shell; };
      modules = [ ./configuration.nix ];
    };
  };
}
