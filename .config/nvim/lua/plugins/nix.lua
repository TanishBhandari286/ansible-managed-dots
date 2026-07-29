return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- `nil` is provided by nixpkgs (nix-for-mac/modules/system/packages.nix),
        -- not Mason -- Mason can only install it via `cargo`, which isn't on
        -- PATH here, so it fails every time it tries.
        nil_ls = { mason = false },
      },
    },
  },
}
