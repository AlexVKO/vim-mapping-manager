# VimMappingManager(WIP)

This is a plugin that takes your vim mappings to the next level, by using it you will gain:

- [x] Simplicity, readability, and extensibility.
- [x] Out-of-the-box integration with vim-which-key
- [x] Run time checkers and validations. (ex: duplicated mappings)
- [ ] Ability to create Ruby methods to be executed by VIM mappings.
- [x] Run time helpers.(ex: current_file_path, current_line)
- [ ] Auto-generated markdown documentation.

This:
```ruby
  leader('<space>') do
    normal('a', '=ip', desc: 'Indent paragraph')
    normal('e', 'gg=G<C-O>', desc: 'indent current file')
  end

  visual('s', ":s//g#{move_cursor(2, :chars, :left)}", desc: 'Substitute inside selection')

  prefix(',', name: 'Files', desc: 'Mappings related to file manipulation') do
    normal('c', ":saveas #{current_file_path}", desc: "Duplicate current file")
    normal('r', ':checktime',                   desc: 'Reload the file')
    normal('d', ':!rm %',                       desc: 'Delete current file')
  end

  prefix(',', name: 'Files', desc: 'Mappings related to file manipulation', filetype: :ruby) do
    normal('c', ":CreateRSpec(#{current_file_path})", desc: "Create RSpec file")
  end

  prefix ';', name: 'FuzzyFinder', desc: 'Search everything' do
    prefix 'r', name: 'Rails', desc: 'Search in Rails directories' do
      normal 'm', ':Files <cr> app/models/', desc: 'Find for models'
      normal 'c', ':Files <cr> app/controllers/', desc: 'Find for controllers'
    end
  end

  command('Reload', ':so ~/.config/nvim/init.vim', desc: 'Reload VIM')
```

Generates this:
```
  " ----------------------------------------------------------------
  " Leader
  " ----------------------------------------------------------------
  let mapleader='<space>'

  if !exists('g:which_key_map')
    let g:which_key_map = {}
  endif
  call which_key#register('<space>', 'g:which_key_map')
  nnoremap <space> :<c-u>WhichKey '<space>'<CR>
  vnoremap <space> :<c-u>WhichKeyVisual '<space>'<CR>

  " Indent paragraph
  nnoremap <silent> <space>a =ip
  call extend(g:which_key_map, {'a':'Indent paragraph'})

  " indent current file
  nnoremap <silent> <space>e gg=G<C-O>
  call extend(g:which_key_map, {'e':'Indent current file'})

  " Substitute inside selection
  xnoremap <silent> s :s//g<Left><Left>


  " ----------------------------------------------------------------
  " Prefix Files
  " Key ,
  " Mappings related to file manipulation
  " ----------------------------------------------------------------
  let g:which_key_map_files = { 'name' : '+Files' }
  call which_key#register(',', 'g:which_key_map_files')
  nnoremap , :<c-u>WhichKey ','<CR>
  vnoremap , :<c-u>WhichKeyVisual ','<CR>

  " Duplicate current file
  nnoremap <silent> ,c :saveas <C-R>=expand('%')<CR>
  call extend(g:which_key_map_files, {'c':'Duplicate current file'})

  " Reload the file
  nnoremap <silent> ,r :checktime
  call extend(g:which_key_map_files, {'r':'Reload the file'})

  " Delete current file
  nnoremap <silent> ,d :!rm %
  call extend(g:which_key_map_files, {'d':'Delete current file'})


  " ----------------------------------------------------------------
  " Prefix Files
  " Key ,
  " Filetype: ruby
  " Mappings related to file manipulation
  " ----------------------------------------------------------------
  let g:which_key_map_files = { 'name' : '+Files' }
  call which_key#register(',', 'g:which_key_map_files')
  nnoremap , :<c-u>WhichKey ','<CR>
  vnoremap , :<c-u>WhichKeyVisual ','<CR>

  " Create RSpec file
  autocmd FileType ruby nnoremap <silent> ,c :CreateRSpec(<C-R>=expand('%')<CR>)
  autocmd FileType ruby call extend(g:which_key_map_files, {'c':'Create rspec file'})


  " ----------------------------------------------------------------
  " Prefix FuzzyFinder
  " Key ;
  " Search everything
  " ----------------------------------------------------------------
  let g:which_key_map_fuzzyfinder = { 'name' : '+FuzzyFinder' }
  call which_key#register(';', 'g:which_key_map_fuzzyfinder')
  nnoremap ; :<c-u>WhichKey ';'<CR>
  vnoremap ; :<c-u>WhichKeyVisual ';'<CR>


    " ----------------------------------------------------------------
    " Prefix FuzzyFinder > Rails
    " Key ;r
    " Search in Rails directories
    " ----------------------------------------------------------------
    let g:which_key_map_fuzzyfinder.r = { 'name' : '+FuzzyFinder > Rails' }

    " Find for models
    nnoremap <silent> ;rm :Files <cr> app/models/
    call extend(g:which_key_map_fuzzyfinder.r, {'m':'Find for models'})

    " Find for controllers
    nnoremap <silent> ;rc :Files <cr> app/controllers/
    call extend(g:which_key_map_fuzzyfinder.r, {'c':'Find for controllers'})


  " ----------------------------------------------------------------
  " Commands
  " ----------------------------------------------------------------
  " Reload VIM
  command! Reload :so ~/.config/nvim/init.vim
```

## Usage

Run `:EditMappings`

The mappings configuration file will open.

![](https://github.com/AlexVKO/vim-mapping-manager/blob/master/docs/example.png)

Once you save this file, the output will be saved to `~/.config/nvim/managed_mappings.vimrc`.

You'll need to add this line to your `~/.config/nvim/init.vim`:

```
source $HOME/.config/nvim/managed_mappings.vimrc
```

## Examples

### Simple map for command mode
```ruby
  normal('<leader>e', 'gg=G', desc: 'Indent current file')
```

### Map to a ruby function
```ruby

normal 'U', desc: 'Make current word UPCASE' do
  # Also could be current_line, current_buffer, current_word, current_line_number, ...
  current_word = current_word.upcase
end

normal 'u', desc: 'Make current word downcase' do
  # Also could be current_buffer, current_word, current_line_number, ...
  current_word = current_word.upcase
end
```

### Prefixes (think of it as multiple leaders)
```ruby
prefix(',', name: 'Files', desc: 'Mappings related to file manipulation') do
  normal('du', ":saveas #{current_file_path}", desc: "Duplicate current file")
  normal('ct', ':checktime', desc: 'Reload the file')
  normal('de', ":!rm #{current_file_path}", desc: 'Delete current file')
  normal('y', ":let @+=#{current_file_path}:#{current_line_number}", desc: 'Relative path copied to clipboard.')
  normal('Y', ":let @+=#{current_file_absolute_path}", desc: 'Absolute path copied to clipboard.')
end
```

Now if you type `,y` it will add the path of current file with the line to your clipboard

### Prefixes/Mappings only for specific languages

```ruby
prefix('R', name: 'Ruby', desc: 'Mappings only for Ruby', filetype: :ruby) do
  normal('ap', 'RExtractLet', desc: 'Transforms local variable under cursor to let')
  normal('eco', 'RExtractConstant', desc: 'Transforms local variable under cursor to constant')
  normal('p', 'RubyEvalPrint', desc: 'Evaluates the code under the cursor and print inline')
  # ...
end
```

### Nested Prefixes
```ruby
prefix ';', name: 'Fuzzy Finder', desc: 'Fuzzy anything' do
  prefix 'r', name: 'Rails', desc: 'Search in Rails directories', filetype: :ruby do
    normal 'mo', ':Files <cr> app/models/', desc: 'Find for models'
    normal 'co', ':Files <cr> app/controllers/', desc: 'Find for controllers'
  end
end
```

now `;rco` will find models inside your rails project

### Helpers
There are several helpers that you can use in this file.
```
current_file_path
current_file_absolute_path
current_line_number
move_cursor(1, :word, :left)

```

### Maping commands
```ruby
command('Reload', ':so ~/.config/nvim/init.vim', desc: 'Reload VIM')
```

### Integration with https://github.com/liuchengxu/vim-which-key
TODO

### Generate markdown documentation
TODO

## Installation

Tested with NEOVIM

### Plugin Manager
Assuming you are using vim-plug:

```
Plug 'leoatchina/vim-which-key' <- Recommended for full experience

Plug 'AlexVKO/vim-mapping-manager', { 'do' : ':UpdateRemotePlugins' }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AlexVKO/vim_mapping_manager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/AlexVKO/vim_mapping_manager/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VimMappingManager project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/AlexVKO/vim_mapping_manager/blob/master/CODE_OF_CONDUCT.md).
