RSpec.describe VimMappingManager do
  it "has a version number" do
    expect(VimMappingManager::VERSION).not_to be "0.1.0"
  end

  before do
    OutputFile.reset!
    VimMappingManager.reset!
  end

  describe 'Full mapping example' do
    specify do
      described_class.call do
        leader('<space>') do
          normal('a', '=ip', desc: 'Indent paragraph')
        end

        normal('e', 'gg=G<C-O>', desc: 'indent current file')
        visual('s', ":s//g#{move_cursor(2, :chars, :left)}", desc: 'Substitute inside selection')

        prefix(',', name: 'Files', desc: 'Mappings related to file manipulation') do
          normal('du', ":saveas #{current_file_path}", desc: "Duplicate current file")
          normal('ct', ':checktime',                   desc: 'Reload the file')
          normal('de', ':!rm %',                       desc: 'Delete current file')
        end

        command('Reload', ':so ~/.config/nvim/init.vim', desc: 'Reload VIM')
      end

      expected = <<-EXPECTED
        " ----------------------------------------------------------------
        " Leader, key: <space>
        " ----------------------------------------------------------------
        let mapleader='<space>'

        if !exists('g:which_key_map')
          let g:which_key_map = {}
        endif
        if exists(':WhichKey')
          call which_key#register('<space>', 'g:which_key_map')
        endif

        " Indent paragraph
        nnoremap <silent> <space>a =ip
        let g:which_key_map.a = 'Indent paragraph'

        " indent current file
        nnoremap <silent> e gg=G<C-O>

        " Substitute inside selection
        xnoremap <silent> s :s//g<Left><Left>


        " ----------------------------------------------------------------
        " Prefix: Files, key: ,
        " Mappings related to file manipulation
        " ----------------------------------------------------------------
        let g:which_key_map_files = { 'name' : '+files' }
        if exists(':WhichKey')
          call which_key#register(',', 'g:which_key_map_files')
        endif

        nnoremap , :<c-u>WhichKey ','<CR>
        vnoremap , :<c-u>WhichKeyViual ','<CR>

        " Duplicate current file
        nnoremap <silent> ,du :saveas <C-R>=expand('%')<CR>
        let g:which_key_map_files.du = 'Duplicate current file'

        " Reload the file
        nnoremap <silent> ,ct :checktime
        let g:which_key_map_files.ct = 'Reload the file'

        " Delete current file
        nnoremap <silent> ,de :!rm %
        let g:which_key_map_files.de = 'Delete current file'


        " ----------------------------------------------------------------
        " Commands
        " ----------------------------------------------------------------
        " Reload VIM
        command! Reload :so ~/.config/nvim/init.vim
      EXPECTED

      renders_properly(described_class.render, expected)
    end

    def renders_properly(actual, expected)
      actual = actual#.gsub(/^*/, '')
      expected = expected.gsub(/        /, '')
      expect(actual).to include(expected)
    end
  end
end
