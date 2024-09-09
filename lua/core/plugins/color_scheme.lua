return {
    -- 'RishabhRD/nvim-rdark' -- Theme
    -- 'navarasu/onedark.nvim' -- Theme inspired by Atom
    -- 'marko-cerovac/material.nvim' -- Theme inspired by Atom
    -- 'haishanh/night-owl.vim' -- Theme inspired by Atom
    "tjdevries/colorbuddy.vim",
    config = function()
        -- require('colorbuddy').colorscheme('night-owl')
        require("nightly").setup({
            color = "black", -- blue, green or red
            transparent = false,
            styles = {
                comments = {
                    italic = true
                },
                functions = {
                    italic = false
                },
                keywords = {
                    italic = false
                },
                variables = {
                    italic = false
                }
            },
            highlights = {
                -- add or override highlights
                -- Normal = { bg = "#000000" }
            }
        })
        require("colorbuddy").colorscheme("nightly")
    end,
    dependencies = {{"haishanh/night-owl.vim"}, {"RishabhRD/nvim-rdark"}, {"navarasu/onedark.nvim"},
                    {"marko-cerovac/material.nvim"}, {"Alexis12119/nightly.nvim"}, {"Aryansh-S/fastdark.vim"}},
    lazy = false,
    name = "Color Buddy: Night Owl",
    -- colorschemes need high priority
    priority = 1000
}
