
" ----------------------------------------------------------------
" Leader
" ----------------------------------------------------------------
let mapleader='<space>'

if !exists('g:which_key_map')
  let g:which_key_map = {}
endif
call which_key#register('<leader>', 'g:which_key_map')
nnoremap <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <leader> :<c-u>WhichKeyVisual '<leader>'<CR>

" DO X
autocmd FileType ruby xnoremap <silent> <leader>X :RUN
