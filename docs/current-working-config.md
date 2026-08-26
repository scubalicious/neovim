# Current working Neovim configuration

Snapshot before the Neovim 0.12 and plugin upgrade. This configuration was manually verified on 2026-08-25.

## Restore point

- Repository commit: [`c418527`](https://github.com/scubalicious/neovim/commit/c418527560c4be8b5a6ca28fa7be0103bf63b139)
- Neovim: `0.11.4`
- Neovim binary SHA-256: `79e7e160f9505819a5e12f3d9366be94213f5309fb912ef4ef3af52df3982977`
- Plugin manager: lazy.nvim `6c3bda4aca61a13a9c63f1c1d1b16b9d3be90d7a`
- nvim-treesitter: `28d480e0624b259095e56f353ec911f9f2a0f404`
- nvim-treesitter-textobjects: `ed373482db797bbf71bdff37a15c7555a84dce47`
- Tree-sitter CLI: `0.25.10` (`da6fe9beb4f7f67beb75914ca8e0d48ae48d6406`)
- Telescope: `0.1.x` at `a0bbec21143c7bc5f8bb02e0005fa0b982edc026`
- Mason: `fc98833b6da5de5a9c5b1446ac541577059555be`
- mason-lspconfig: `1a31f824b9cd5bc6f342fc29e9a53b60d74af245`
- nvim-lspconfig: `4bc481b6f0c0cf3671fc894debd0e00347089a4e`

`lazy-lock.json` at the restore-point commit is the authoritative version list for every plugin.

## Known-working features

- TokyoNight `moon` theme and transparency toggle
- Telescope file search, live grep, recent files, LSP pickers, and Todo picker
- nvim-tree explorer
- Treesitter highlighting, indentation, incremental selection, parsers, and text objects
- LaTeX parser generation using Tree-sitter CLI 0.25.10
- Mason-managed tools and conditional R language-server installation
- nvim-cmp completion, LuaSnip, and Copilot completion source
- Conform formatting and nvim-lint diagnostics
- R.nvim integration when `R` is available
- OSC 52 clipboard in the remote workspace

Runtime plugin data, Mason packages, and Treesitter parsers are workspace-local. The configuration and Neovim binary are persisted on the personal share.

## Compatibility constraints

This snapshot intentionally uses the legacy nvim-treesitter API:

```lua
require("nvim-treesitter.configs").setup(...)
```

It therefore requires the frozen nvim-treesitter `master` generation and Tree-sitter CLI 0.25.x. Current nvim-treesitter `main` is an incompatible rewrite requiring Neovim 0.12+ and Tree-sitter CLI 0.26.1+.

The snapshot also uses Mason v1's removed `setup_handlers()` API. Do not update only Mason, mason-lspconfig, or Treesitter while expecting this configuration to remain compatible.

## Restore procedure

```bash
git checkout c418527560c4be8b5a6ca28fa7be0103bf63b139
nvim
```

Then run `:Lazy restore` interactively to restore plugin revisions from `lazy-lock.json`. Ensure Neovim 0.11.4 and Tree-sitter CLI 0.25.10 are on `PATH` before testing parser installation.

Prefer restoring in a temporary worktree or branch rather than moving the active `main` checkout to detached HEAD.
