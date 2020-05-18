

" ----------------------------------------------------------------
" Prefix SampleNestedPrefix
" Key a
" Does more stuff
" ----------------------------------------------------------------
let g:which_key_map_samplenestedprefix = { 'name' : '+SampleNestedPrefix' }
call which_key#register('a', 'g:which_key_map_samplenestedprefix')
nnoremap a :<c-u>WhichKey 'a'<CR>
vnoremap a :<c-u>WhichKeyVisual 'a'<CR>


  " ----------------------------------------------------------------
  " Namespace SampleNestedPrefix > NameSpaceX
  " Key a
  " Filetype: ruby
  " Just a namespace
  " ----------------------------------------------------------------

  " DO C
  autocmd FileType ruby nnoremap aC :RUN<CR>
  autocmd FileType ruby call extend(g:which_key_map_samplenestedprefix, {'C':'Do c'})
