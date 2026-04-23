_: self: _:
let
  inherit (self) merge mkMerge;
in
{
  # When the block has a `_type` attribute in the NixOS
  # module system, anything not immediately relevant is
  # silently ignored. We can make use of that by adding
  # a `__functor` attribute, which lets us call the set.
  merge = mkMerge [ ] // {
    __functor =
      self: next:
      self
      // {
        # Technically, `contents` is implementation defined
        # but nothing ever happens, so we can rely on this.
        contents = self.contents ++ [ next ];
      };
  };

  enabled = merge { enable = true; };
  disabled = merge { enable = false; };

  copyToClipboardShell = "copy_to_clipboard() { if command -v pbcopy >/dev/null 2>&1; then pbcopy; elif command -v wl-copy >/dev/null 2>&1; then wl-copy; elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard; elif command -v xsel >/dev/null 2>&1; then xsel --clipboard --input; else exit 127; fi; }";
}
