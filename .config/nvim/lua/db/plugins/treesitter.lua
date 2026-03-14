return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false, -- IMPORTANT

    opts = {
      ensure_installed = {
        "lua",
        "go",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "html",
        "css",
        "yaml",
        "bash",
        "c",
      },

      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}