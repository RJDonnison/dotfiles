return {
  {
    "Shobhit-Nagpal/nvim-rafce",
    config = function()
      require("rafce")
    end,
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  { "norcalli/nvim-colorizer.lua" },
  {
    "nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = {
            enable_close = false,
          },
        },
      })
    end,
  },
}
