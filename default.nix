with import <nixpkgs> {};
crystal.buildCrystalPackage rec {
  version = "0.1.0";
  pname = "SHAShort";
  src = ./.;

  shardsFile = ./shards.nix;
  crystalBinaries.SHAShort.src = "src/shashort.cr";

  buildInputs = [ sqlite-interactive.dev ];
}
