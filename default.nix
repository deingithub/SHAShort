with import (builtins.fetchTarball {
  # nixpkgs master on 2020-10-14
  url =
    "https://github.com/NixOS/nixpkgs/tarball/d5291756487d70bc336e33512a9baf9fa1788faf";
  sha256 = "0mhqhq21y5vrr1f30qd2bvydv4bbbslvyzclhw0kdxmkgg3z4c92";
}) { };



crystal.buildCrystalPackage rec {
  version = "0.1.0";
  pname = "SHAShort";
  src = ./.;

  shardsFile = ./shards.nix;
  crystalBinaries.SHAShort.src = "src/shashort.cr";
  format = "crystal";

  buildInputs = [ sqlite-interactive.dev ];
}
