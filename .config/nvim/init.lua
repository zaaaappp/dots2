-- set leader
vim.g.mapleader = " "

-- no ~
vim.opt.fillchars = { eob = " " }

-- keymaps
vim.keymap.set('n', '<leader>f', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('t', '<C-f>', [[<C-\><C-n>i]], {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<C-f>', [[<cmd>ToggleTerm<CR><C-w>j i]], {noremap = true, silent = true})


-- alt + , -> <
vim.keymap.set('i', '<M-,>', '<')
vim.keymap.set('n', '<M-,>', '<')

-- alt + . -> >
vim.keymap.set('i', '<M-.>', '>')
vim.keymap.set('n', '<M-.>', '>')


exitTerm = function()
  vim.cmd(":ToggleTerm");
end



-- enable true transparency
vim.o.termguicolors = true
vim.cmd([[highlight Normal guibg=NONE]])
vim.cmd([[highlight NormalNC guibg=NONE]])   -- inactive windows
vim.cmd([[highlight SignColumn guibg=NONE]]) -- gutter
vim.cmd([[highlight VertSplit guibg=NONE]])  -- vertical split
vim.cmd([[highlight StatusLine guibg=NONE]])
vim.cmd([[highlight LineNr guibg=NONE]])
vim.cmd([[highlight CursorLineNr guibg=NONE]])

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
    -- nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
            require("nvim-tree.api").tree.toggle({ focus = false })
        end
    },

    -- toggleterm
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup{
                size = 8,
                open_mapping = [[<c-t>]],
                direction = "horizontal",
                start_in_insert = true,
                persist_size = true,
                shade_terminals = true,
                close_on_exit = false,
            }
        end
    },

    -- treesitter for java syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup{
                ensure_installed = { "java" },
                highlight = { enable = true },
                indent = { enable = true },
            }
        end
    },
   
    -- auto pairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup{}
        end
    },


    -- completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                })
            })
        end
    },
})
