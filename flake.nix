{
  description = "OpenZiti";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
      rev = "v1.0.0";
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.buildGo122Module {
          name = "openziti";
          subPackages = [ "ziti" ];
          src = pkgs.fetchFromGitHub {
            owner = "openziti";
            repo = "ziti";
            rev = rev;
            sha256 = "sha256-2li/+XWKk+lybB1DE0unKvQrA0pKE9VIRFoEYMcbLS8=";
          };
          vendorHash = "sha256-uyjQd5kB61UEKSl1Qf1Gu6Fr40l4KixHSnEtTMq58Vc=";
          ldflags = [
            "-X github.com/openziti/ziti/common/version.Version=${rev}"
          ];
        };
      });
    };
}
