call plug#begin()
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'nvim-lua/plenary.nvim' 
  Plug 'rust-lang/rust.vim'
  Plug 'preservim/nerdtree'
  Plug 'tikhomirov/vim-glsl'
  Plug 'bfrg/vim-cpp-modern'
  Plug 'willothy/nvim-cokeline'
call plug#end()

lua << EOF

  local get_hex = require('cokeline.hlgroups').get_hl_attr

  local yellow = vim.g.terminal_color_3

  require('cokeline').setup({
    show_if_buffers_are_at_least = 2,
    default_hl = {
      fg = function(buffer)
        return
          buffer.is_focused
          and get_hex('Normal', 'fg')
           or get_hex('Comment', 'fg')
      end,
      bg = function() return get_hex('ColorColumn', 'bg') end,
      underline = true,
    },

    sidebar = {
      filetype = {'NvimTree', 'neo-tree', 'nerdtree'},
      components = {
        {
          text = '',
          bold = true,
          fg = function(buffer)
            return
              buffer.is_focused
              and get_hex('Normal', 'fg')
              or get_hex('Comment', 'fg')
          end,
          underline = false,
        },
      }
    },

    components = {
      {
        text = function(buffer) return '│' end,
      },
      {
        text = '  ',
      },
      {
        text = function(buffer) return buffer.filename .. '  ' end,
        bold = function(buffer)
          return buffer.is_focused
        end,
      },
    },
  })

EOF

set filetype=glslx

set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

let NERDTreeMinimalUI=1
nmap <C-n> :NERDTreeToggle<CR>

"" no one is really happy until you have this shortcuts

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

set autoindent
set expandtab
set tabstop=4
set shiftwidth=2

set hidden

"" Window Navigation with Ctrl-[hjkl]
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

noremap <C-DOWN> <C-W>j
noremap <C-UP> <C-W>k
noremap <C-LEFT> <C-W>h
noremap <C-RIGHT> <C-W>l

noremap <A-J> <Plug>(cokeline-switch-prev)
noremap <A-K> <Plug>(cokeline-switch-next)
noremap <A-H> <Plug>(cokeline-focus-prev)
noremap <A-L> <Plug>(cokeline-focus-next)

noremap <A-DOWN> <Plug>(cokeline-switch-prev)
noremap <A-UP> <Plug>(cokeline-switch-next)
noremap <A-LEFT> <Plug>(cokeline-focus-prev)
noremap <A-RIGHT> <Plug>(cokeline-focus-next)


"" so autosuggestion box is only 20 tall
"" but still can scroll
set pumheight=20


"" absolute line number in insert mode
"" relative line number otherwise
set number

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

