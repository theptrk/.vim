# .vim

My vim setup. Clone to `~/.vim` and vim finds everything — vim reads
`~/.vim/vimrc` natively, so there is no `~/.vimrc` and no symlinks.

## Restore on a new machine

```sh
git clone --recurse-submodules https://github.com/theptrk/.vim.git ~/.vim
brew install fzf ripgrep
```

`fzf` provides the fuzzy finder the vimrc loads from `/opt/homebrew/opt/fzf`;
`ripgrep` powers the `:RG` live-grep mapping.

## Plugins

Managed as git submodules under `pack/plugins/start/` (vim 8 native packages,
no plugin manager):

- [fzf.vim](https://github.com/junegunn/fzf.vim) — fuzzy file/buffer/grep pickers
- [nerdtree](https://github.com/preservim/nerdtree) — file tree
- [vim-which-key](https://github.com/liuchengxu/vim-which-key) — leader-key popup menu

Update all plugins:

```sh
git submodule update --remote --merge
```
