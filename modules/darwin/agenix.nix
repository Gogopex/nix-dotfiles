{ config, lib, pkgs, ... }:

{
  age.identityPaths = [
    "/Users/ludwig/.ssh/id_ed25519"
    "/Users/ludwig/.ssh/id_rsa"
  ];
}