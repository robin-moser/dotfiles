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
                -- kubernetes schema
                [require("kubernetes").yamlls_schema()] = {
                  -- k8s directories
                  "manifests/**/*.{yml,yaml}",
                  "kubernetes/**/*.{yml,yaml}",
                  "k8s/**/*.{yml,yaml}",
                  -- single k8s definition files
                  "*kubernetes*.{yml,yaml}",
                  "*k8s*.{yml,yaml}",
                },
                -- k8s kustomize schema
                ["https://www.schemastore.org/kustomization.json"] = {
                  "kustomization.{yml,yaml}",
                },
                -- github workflow schema
                ["https://www.schemastore.org/github-workflow"] = {
                  ".github/workflows/*",
                },
                -- resticprofile schema
                ["https://creativeprojects.github.io/resticprofile/jsonschema/config.json"] = {
                  "restic/*.yaml",
                  "resticprofile/*.yaml",
                },
              },
            },
          },
        },
      },
    },
  },
}
