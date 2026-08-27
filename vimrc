" Use space as the leader key. Must come before any <leader> mappings.
let mapleader = " "

syntax on
filetype plugin indent on

" A vimrc's presence makes vim skip its built-in defaults.vim, so basics like
" ruler and incsearch are off unless set here.
set ruler

" Case-insensitive search unless the pattern contains a capital letter.
set ignorecase smartcase
" Highlight all matches, and highlight while still typing the pattern.
set hlsearch incsearch
" Ctrl-l clears search highlighting (and still redraws, its default job).
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Indentation defaults: 4-column indents as spaces. Language indent files
" loaded by `filetype plugin indent on` override these per filetype.
set shiftwidth=4 tabstop=4 softtabstop=4 expandtab smarttab

" Toggle the NERDTree file tree with <leader>n (space + n)
nnoremap <leader>n :NERDTreeToggle<CR>
" Reveal the current file in the tree with <leader>f
nnoremap <leader>f :NERDTreeFind<CR>
" Show dotfiles in NERDTree by default
let NERDTreeShowHidden=1

" fzf: load the base plugin shipped by Homebrew (provides fzf#run, required by fzf.vim)
set rtp+=/opt/homebrew/opt/fzf
" Recent files (fuzzy, with preview)
nnoremap <leader>r :History<CR>
" Fuzzy-find any file by name
nnoremap <leader>p :Files<CR>
" Search file contents with ripgrep (live: re-runs rg on every keystroke)
nnoremap <leader>g :RG<CR>
" Switch between open buffers
nnoremap <leader>b :Buffers<CR>

" which-key: press <leader> (space) to pop up a menu of leader mappings.
" timeoutlen controls how long Vim waits before the popup appears.
set timeoutlen=500
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
let g:which_key_map = {
  \ 'n': [':NERDTreeToggle', 'toggle file tree'],
  \ 'f': [':NERDTreeFind',   'reveal current file in tree'],
  \ 'p': [':Files',          'find files by name'],
  \ 'r': [':History',        'recent files'],
  \ 'g': [':RG',             'search file contents'],
  \ 'b': [':Buffers',        'switch buffers'],
  \ }
autocmd VimEnter * call which_key#register('<Space>', 'g:which_key_map')

" --- which-key popup colors -------------------------------------------------
" vim-which-key draws its popup using the WhichKey* highlight groups, which by
" default link to vim's built-in groups (WhichKeyFloating -> Pmenu, etc.). With
" no colorscheme set, vim's default Pmenu is light-magenta and Identifier is
" yellow -> the popup renders as bright purple with yellow text, unreadable.
" These overrides repaint it to match the GitHub Dark High Contrast palette.
" termguicolors is required for the #hex values below to take effect.
set termguicolors

" Define the colors in a function (one :highlight per line, no line-continuation
" needed) and re-apply on every colorscheme load so a future :colorscheme can't
" clobber it. VimEnter fires once at startup to paint the initial colors.
function! s:WhichKeyColors() abort
  highlight WhichKeyFloating  guibg=#161b22 guifg=#f0f3f6
  highlight WhichKey          guibg=#161b22 guifg=#71b7ff
  highlight WhichKeyGroup     guibg=#161b22 guifg=#26cd4d
  highlight WhichKeyDesc      guibg=#161b22 guifg=#f0f3f6
  highlight WhichKeySeperator guibg=#161b22 guifg=#7a828e
endfunction
augroup WhichKeyColors
  autocmd!
  autocmd ColorScheme,VimEnter * call s:WhichKeyColors()
augroup END

autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.beancount set filetype=beancount
set directory=~/.vim/swap//

" Wrap long lines at word boundaries instead of breaking mid-word
set linebreak

inoremap fd <Esc>

" Move by display lines on wrapped text, but keep counts (e.g. 5j) jumping by
" logical lines so relative line numbers still work as expected.
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'
