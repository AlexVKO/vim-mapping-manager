# VimMappingManager(WIP)

This is a plugin that takes your vim mappings to the next level, by using it you will gain:

- Simplicity, readability, and extensibility.
- Out-of-the-box integration with vim-which-key
- Run time checkers and validations. (ex: duplicated mappings)
- Ability to create Ruby methods to be executed by VIM mappings.
- Run time helpers.(ex: current_file_path, current_line)
- Auto-generated documentation.

This:
```ruby
normal('<leader>e', 'gg=G', desc: 'indent current file')

prefix(',', name: 'Files', desc: 'Mappings related to file manipulation') do
  normal('du', ":saveas #{current_file_path}", desc: "Duplicate current file")
  normal('ct', ':checktime',                   desc: 'Reload the file')
  normal('de', ':!rm %',                       desc: 'Delete current file')
end
```

Generates this:
```
" indent current file
nnoremap <silent> <leader>e gg=G<C-O>

" ----------------------------------------------------------------
" Prefix: Files, key: ,
" Mappings related to file manipulation
" ----------------------------------------------------------------
nnoremap  [Files] <Nop>
nmap      , [Files]

" Duplicate current file
nnoremap <silent> [Files]du :saveas <C-R>=expand('%')<CR>

" Reload the file
nnoremap <silent> [Files]ct :checktime

" Delete current file
nnoremap <silent> [Files]de :!rm %
```
## Usage

Run `:EditMappings`

The mappings configuration file will open.

[Image here]

Once you save this file, the output will be saved to `~/.config/nvim/managed_mappings.vimrc`.

Add this line to your `~/.config/nvim/init.vim`:

```
source $HOME/.config/nvim/managed_mappings.vimrc
```

## Examples

### Simple map for command mode
```ruby
  normal('<leader>e', 'gg=G', desc: 'Indent current file')
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

### Helpers
There are several helpers that you can use in this file.
```
current_file_path
current_file_absolute_path
current_line_number
move_cursor(1, :word, :left)

```

### Integration with https://github.com/liuchengxu/vim-which-key
TODO

### Generate markdown documentation
TODO

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vim_mapping_manager'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install vim_mapping_manager

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AlexVKO/vim_mapping_manager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/AlexVKO/vim_mapping_manager/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VimMappingManager project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/AlexVKO/vim_mapping_manager/blob/master/CODE_OF_CONDUCT.md).
