{ system ? builtins.currentSystem
, nixpkgs ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  }
, pkgs ? import nixpkgs {
    overlays = [ ];
    config = { };
    inherit system;
  }
}:
let
  ruby = pkgs.ruby_3_2;
  bundler = pkgs.bundler.override { inherit ruby; };
  bundix = pkgs.bundix.override { inherit bundler; };
  gems = pkgs.bundlerEnv.override { inherit bundler; } {
    name = "gems";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
{
  default = pkgs.mkShell {
    buildInputs = [
      gems
      gems.wrappedRuby
    ];
  };
  update = pkgs.mkShell {
    buildInputs = [
      bundix
      ruby
    ];
  };
}
