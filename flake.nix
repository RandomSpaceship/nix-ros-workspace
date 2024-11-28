{
  description = "Workspace builder for ROS based on lopsided98/nix-ros-overlay";

  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs"; # IMPORTANT!!!
  };

  outputs =
    {
      self,
      nix-ros-overlay,
      nixpkgs,
    }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # add the requisite ROS overlay
            nix-ros-overlay.overlays.default
            # and import our own workspace
            (import ./overlay)
          ];
        };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
