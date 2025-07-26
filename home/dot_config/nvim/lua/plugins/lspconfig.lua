return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              format = {
                enable = true,
                singleQuote = true,
                printWidth = 120,
              },
              hover = true,
              completion = true,
              validate = true,
              schemas = {
                [require("kubernetes").yamlls_schema()] = "*.yaml",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              },
            },
          },
        },
      },
    },
  },
}
