# .vim

Vim configuration with plugins vendored as git submodules. Cloning this repo
to `~/.vim` is the whole install — vim reads `~/.vim/vimrc` natively, so there
is no `~/.vimrc` and nothing to symlink.

## New machine

```sh
git clone --recurse-submodules https://github.com/theptrk/.vim.git ~/.vim
brew install fzf ripgrep
```

`fzf` is loaded from `/opt/homebrew/opt/fzf` by the vimrc; `ripgrep` backs the
`:RG` live grep. If a `~/.vimrc` file exists, vim uses it instead of this
repo's `vimrc` — delete it.

## Keys

Leader is space. Press space and wait 500ms for a which-key popup listing
these mappings:

| Keys | Action |
|---|---|
| `space n` | toggle the NERDTree file tree |
| `space f` | reveal the current file in the tree |
| `space p` | fuzzy-find files by name (`:Files`) |
| `space r` | recent files (`:History`) |
| `space g` | live-grep file contents with ripgrep (`:RG`) |
| `space b` | switch between open buffers |
| `fd` in insert mode | escape |

`j`/`k` move by display lines on wrapped text; with a count (`5j`) they move
by logical lines, so relative line numbers still work.

## Plugins

Native vim 8 packages under `pack/plugins/start/` — no plugin manager. Each
plugin is a git submodule pinned to a commit.

- [fzf.vim](https://github.com/junegunn/fzf.vim) — file/buffer/grep pickers
  (the base fzf plugin it needs comes from Homebrew, not this repo)
- [nerdtree](https://github.com/preservim/nerdtree) — file tree
- [vim-which-key](https://github.com/liuchengxu/vim-which-key) — leader-key
  popup menu

Add a plugin:

```sh
git submodule add https://github.com/user/plugin.git pack/plugins/start/plugin
git commit -m "Add plugin"
```

Update all plugins to their latest commits:

```sh
git submodule update --remote --merge
git commit -am "Update plugins"
```

Remove a plugin:

```sh
git submodule deinit -f pack/plugins/start/plugin
git rm -f pack/plugins/start/plugin
git commit -m "Remove plugin"
```

## Details

- Swap files go to `~/.vim/swap/`, which ships with the repo but its contents
  are git-ignored.
- The which-key popup is repainted to GitHub Dark High Contrast colors in the
  vimrc (vim's default Pmenu colors make it unreadable); `termguicolors` is on
  so the hex values take effect.
- `after/ftplugin/beancount.vim` sets 2-space indentation for `*.beancount`
  files.
