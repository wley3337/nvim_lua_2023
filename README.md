# NEOVIM LUA CONFIG

## Idea
Seperate core functionality and specific additions/modifications. Essentially to have a personal setup that can be different from a work setup.

## Inspiration, guides, and all around learnings
- [TJ Devries](https://github.com/tjdevries)
- [The Primeagen](https://github.com/ThePrimeagen)
- [Dane Harnett](https://github.com/dane-harnett)


## Installs outside the pluging ( may not be as up to date as I like :joy: )
- `brew install ripgrep`
-  [install nerd fonts](https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e)

## Clean install
Delete `rm -rf ~/.local/share/nvim`
Delete `rm -rf ~/.config/nvim`

## Patterns
some files are exported modules with `init` functions and some are not.
Not sure if the inconsistancy prevents extra lines of code VS a mix of patterns.
