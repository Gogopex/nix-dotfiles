final: prev: {
  fish = prev.fish.overrideAttrs (old: {
    doCheck = false;
  });
  vault = prev.vault.overrideAttrs (old: {
    doCheck = false;
  });
}
