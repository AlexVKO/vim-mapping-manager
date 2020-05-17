RSpec.describe VimMappingManager do
  it "has a version number" do
    expect(VimMappingManager::VERSION).not_to be "0.1.0"
  end

  it 'Full Mapping example' do
    described_class.call do
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

      prefix ';', name: 'FuzzyFinder', desc: 'Search everything' do
        prefix 'r', name: 'Rails', desc: 'Search in Rails directories' do
          normal 'm', ':Files <cr> app/models/', desc: 'Find for models'
          normal 'c', ':Files <cr> app/controllers/', desc: 'Find for controllers'
        end
      end

      command('Reload', ':so ~/.config/nvim/init.vim', desc: 'Reload VIM')
    end

    expected = <<-EXPECTED
      " ----------------------------------------------------------------
      " Leader
      " ----------------------------------------------------------------
      let mapleader='<space>'

      if !exists('g:which_key_map')
        let g:which_key_map = {}
      endif
      call which_key#register('<space>', 'g:which_key_map')
      nnoremap <space> :<c-u>WhichKey '<space>'<CR>
      vnoremap <space> :<c-u>WhichKeyViual '<space>'<CR>

      "Indent paragraph
      nnoremap <silent> <space>a =ip
      call extend(g:which_key_map, {'a':'Indent paragraph'})

      "indent current file
      nnoremap <silent> <space>e gg=G<C-O>
      call extend(g:which_key_map, {'e':'Indent current file'})

      "Substitute inside selection
      xnoremap <silent> s :s//g<Left><Left>


      " ----------------------------------------------------------------
      " Prefix: Files
      " Key ,
      " Mappings related to file manipulation
      " ----------------------------------------------------------------
      let g:which_key_map_files = { 'name' : '+Files' }
      call which_key#register(',', 'g:which_key_map_files')
      nnoremap , :<c-u>WhichKey ','<CR>
      vnoremap , :<c-u>WhichKeyVisual ','<CR>

      "Duplicate current file
      nnoremap <silent> ,c :saveas <C-R>=expand('%')<CR>
      call extend(g:which_key_map_files, {'c':'Duplicate current file'})

      "Reload the file
      nnoremap <silent> ,r :checktime
      call extend(g:which_key_map_files, {'r':'Reload the file'})

      "Delete current file
      nnoremap <silent> ,d :!rm %
      call extend(g:which_key_map_files, {'d':'Delete current file'})


      " ----------------------------------------------------------------
      " Prefix: FuzzyFinder
      " Key ;
      " Search everything
      " ----------------------------------------------------------------
      let g:which_key_map_fuzzyfinder = { 'name' : '+FuzzyFinder' }
      call which_key#register(';', 'g:which_key_map_fuzzyfinder')
      nnoremap ; :<c-u>WhichKey ';'<CR>
      vnoremap ; :<c-u>WhichKeyVisual ';'<CR>


        " ----------------------------------------------------------------
        " Prefix: FuzzyFinder > Rails
        " Key ;r
        " Search in Rails directories
        " ----------------------------------------------------------------
        let g:which_key_map_fuzzyfinder.r = { 'name' : '+FuzzyFinder > Rails' }

        "Find for models
        nnoremap <silent> ;rm :Files <cr> app/models/
        call extend(g:which_key_map_fuzzyfinder.r, {'m':'Find for models'})

        "Find for controllers
        nnoremap <silent> ;rc :Files <cr> app/controllers/
        call extend(g:which_key_map_fuzzyfinder.r, {'c':'Find for controllers'})


      " ----------------------------------------------------------------
      " Commands
      " ----------------------------------------------------------------
      " Reload VIM
      command! Reload :so ~/.config/nvim/init.vim
    EXPECTED

    renders_properly(described_class.render, expected)
  end

  def renders_properly(actual, expected)
    actual = actual
    expected = expected.gsub(/      /, '')
    expect(actual.lines).to include(*expected.lines), 'asdf'
  end
end
