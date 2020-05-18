
" ----------------------------------------------------------------
" Leader
" ----------------------------------------------------------------
let mapleader='<space>'

if !exists('g:which_key_map')
  let g:which_key_map = {}
endif
call which_key#register('<space>', 'g:which_key_map')
nnoremap <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <leader> :<c-u>WhichKeyVisual '<leader>'<CR>

" DO X
autocmd FileType ruby xnoremap <leader>X :RUN<CR>
