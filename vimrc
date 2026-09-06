" Use space as the leader key. Must come before any <leader> mappings.
let mapleader = " "

" Save the current file with <leader>w (Space, then w).
nnoremap <leader>w :write<CR>

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

" Create folds automatically from indentation; zM closes all folds.
set foldmethod=indent

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
set timeoutlen=1500
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
let g:which_key_map = {
  \ 'w': [':write',          'save file'],
  \ 'n': [':NERDTreeToggle', 'toggle file tree'],
  \ 'f': [':NERDTreeFind',   'reveal current file in tree'],
  \ 'p': [':Files',          'find files by name'],
  \ 'r': [':History',        'recent files'],
  \ 'g': [':RG',             'search file contents'],
  \ 'b': [':Buffers',        'switch buffers'],
  \ }
call which_key#register('<Space>', 'g:which_key_map')

" --- which-key popup colors -------------------------------------------------
" vim-which-key draws its popup using the WhichKey* highlight groups, which by
" default link to vim's built-in groups (WhichKeyFloating -> Pmenu, etc.). With
" no colorscheme set, vim's default Pmenu is light-magenta and Identifier is
" yellow -> the popup renders as bright purple with yellow text, unreadable.
" These overrides repaint it to match Gruvbox Material.
" termguicolors is required for the #hex values below to take effect.
set termguicolors
set background=dark
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_foreground = 'material'
colorscheme gruvbox-material

" Define the colors in a function (one :highlight per line, no line-continuation
" needed) and re-apply on every colorscheme load so a future :colorscheme can't
" clobber it. VimEnter fires once at startup to paint the initial colors.
function! s:WhichKeyColors() abort
  highlight WhichKeyFloating  guibg=#282828 guifg=#d4be98
  highlight WhichKey          guibg=#282828 guifg=#7daea3
  highlight WhichKeyGroup     guibg=#282828 guifg=#a9b665
  highlight WhichKeyDesc      guibg=#282828 guifg=#d4be98
  highlight WhichKeySeperator guibg=#282828 guifg=#928374
endfunction
augroup WhichKeyColors
  autocmd!
  autocmd ColorScheme,VimEnter * call s:WhichKeyColors()
augroup END

autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.beancount set filetype=beancount
set directory=~/.vim/swap//

" Automatically notice files changed outside Vim (for example by an editor or agent).
set autoread
augroup AutoReloadExternalChanges
  autocmd!
  autocmd FocusGained,BufEnter * checktime
augroup END

" Wrap long lines at word boundaries instead of breaking mid-word
set linebreak
set nowrap

inoremap fd <Esc>

" Language-server navigation. vim-lsp-settings registers an installed server;
" these buffer-local mappings activate only after that server is ready.
function! s:OnLspBufferEnabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
endfunction

augroup LspMappings
  autocmd!
  autocmd User lsp_buffer_enabled call s:OnLspBufferEnabled()
augroup END

" Move by display lines on wrapped text, but keep counts (e.g. 5j) jumping by
" logical lines so relative line numbers still work as expected.
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'

" Start a Cursor Agent chat in a new Ghostty split from a Visual selection.
function! s:AskAgentSelection() abort
  let prompt = input('Ask Agent: ')
  if empty(prompt)
    return
  endif
  let file_path = expand('%:p')
  let first_line = line("'<")
  let last_line = line("'>")
  let selected_code = join(getline("'<", "'>"), "\n")
  let initial_prompt = prompt . "\n\nFile: " . file_path
    \ . "\nLines: " . first_line . "-" . last_line
    \ . "\n\nSelected code:\n```\n" . selected_code . "\n```"
  let project_dir = getcwd()
  let shell_command = 'agent --workspace ' . shellescape(project_dir)
    \ . ' ' . shellescape(initial_prompt) . "\n"
  let apple_script = [
    \ 'on run argv',
    \ 'set shellCommand to item 1 of argv',
    \ 'tell application "Ghostty"',
    \ 'set currentTerm to focused terminal of selected tab of front window',
    \ 'set newTerm to split currentTerm direction right',
    \ 'input text shellCommand to newTerm',
    \ 'focus newTerm',
    \ 'end tell',
    \ 'end run',
    \ ]
  let command = ['osascript']
  for script_line in apple_script
    call extend(command, ['-e', script_line])
  endfor
  call add(command, shell_command)
  " Vim's system() requires a String, unlike Neovim which also accepts a List;
  " shell-escape each argument before joining to preserve spaces and newlines.
  let result = system(join(map(copy(command), 'shellescape(v:val)'), ' '))
  if v:shell_error
    echohl ErrorMsg
    echom 'Could not open Agent in Ghostty: ' . result
    echohl None
  endif
endfunction
vnoremap <leader>a :<C-U>call <SID>AskAgentSelection()<CR>
