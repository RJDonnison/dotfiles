-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.shell = "zsh"

vim.opt.clipboard = "unnamedplus"

vim.filetype.add({ extension = { ejs = "ejs" } })
vim.treesitter.language.register("html", "ejs")
vim.treesitter.language.register("javascript", "ejs")
vim.treesitter.language.register("embedded_template", "ejs")
