### nvim-linterconfig

nvim-linterconfig is a collection of linter configurations for
[nvim-lint].

Smartly enables and disables linters based on context cues.

[nvim-lint]: https://github.com/mfussenegger/nvim-lint

### Instalation

Using [lazy.nvim]

```lua
return {
    "skeletony007/nvim-linterconfig",

    dependencies = { "mfussenegger/nvim-lint" },
}
```

[lazy.nvim]: https://github.com/folke/lazy.nvim

### Usage

Enable a particular linter:

```lua
require("linterconfig").stylua.setup()
```

### Acknowledgements

- [nvim-lspconfig] for the plugin structure
- [nvimdev/guard.nvim] for the simple user config

[nvim-lspconfig]:
https://github.com/neovim/nvim-lspconfig/tree/4ea9083b6d3dff4ddc6da17c51334c3255b7eba5
[nvimdev/guard.nvim]: https://github.com/nvimdev/guard.nvim
