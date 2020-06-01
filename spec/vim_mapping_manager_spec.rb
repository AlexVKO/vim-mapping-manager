RSpec.describe VimMappingManager do
  before do
    OutputFile.reset!
    VimMappingManager.reset!
  end

  context 'Command' do
    it 'renders simple commands' do
      config_file do
        command('CommandX', ':trigger', desc: 'CommandX desc')
      end

      expected = <<-EXPECTED
        " CommandX desc
        command! CommandX :trigger
      EXPECTED

      renders_properly(expected)
    end

    it 'renders commands with filetype' do
      config_file do
        command('CommandX', ':trigger', desc: 'CommandX desc', filetype: :ruby)
      end

      expected = <<-EXPECTED
        " CommandX desc
        autocmd FileType ruby command! CommandX :trigger
      EXPECTED

      renders_properly(expected)
    end
  end

  context 'without Prefix' do
    context 'Normal commands' do
      it 'renders simple normal commands' do
        config_file do
          normal 'X', ':RUN', desc: 'DO X'
        end

        expected = <<-EXPECTED
        " DO X
        nnoremap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders Ruby mappings' do
        config_file do
          normal 'X', desc: 'DO X' do |nvim|
            puts 'Global'
          end

          normal 'X', desc: 'DO X', filetype: :ruby do |nvim|
            puts 'For ruby'
          end
        end

        expected = <<-EXPECTED
          " DO X
          nnoremap X :call ExecuteRubyMapping('X', 'all')<CR>

          " DO X
          autocmd FileType ruby nnoremap X :call ExecuteRubyMapping('X', 'ruby')<CR>
        EXPECTED

        expect(ExecuteRubyMapping.fetch('X', 'ruby')).to respond_to :call
        expect(ExecuteRubyMapping.fetch('X', 'all')).to respond_to :call
        expect(ExecuteRubyMapping.commands.count).to be 2

        renders_properly(expected)
      end

      it 'renders simple normal commands(without executing)' do
        config_file do
          normal 'X', ':RUN', desc: 'DO X', execute: false
        end

        expected = <<-EXPECTED
        " DO X
        nnoremap X :RUN
        EXPECTED

        renders_properly(expected)
      end

      it 'renders simple normal commands(recursively)' do
        config_file do
          normal 'X', ':RUN', desc: 'DO X', recursively: true
        end

        expected = <<-EXPECTED
        " DO X
        nmap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders normal commands with filetype' do
        config_file do
          normal 'X', ':RUN', desc: 'DO X', filetype: :ruby
        end

        expected = <<-EXPECTED
        " DO X
        autocmd FileType ruby nnoremap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end
    end

    context 'Visual commands' do
      it 'renders simple visual commands' do
        config_file do
          visual 'X', ':RUN', desc: 'DO X'
        end

        expected = <<-EXPECTED
        " DO X
        xnoremap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders Ruby mappings' do
        config_file do
          visual 'X', desc: 'DO X' do
            puts 'Global'
          end

          visual 'X', desc: 'DO X', filetype: :ruby do
            puts 'For ruby'
          end
        end

        expected = <<-EXPECTED
          " DO X
          xnoremap X :call ExecuteRubyMapping('X', 'all')<CR>

          " DO X
          autocmd FileType ruby xnoremap X :call ExecuteRubyMapping('X', 'ruby')<CR>
        EXPECTED

        expect(ExecuteRubyMapping.fetch('X', 'ruby')).to respond_to :call
        expect(ExecuteRubyMapping.fetch('X', 'all')).to respond_to :call
        expect(ExecuteRubyMapping.commands.count).to be 2

        renders_properly(expected)
      end

      it 'renders simple normal commands(without executing)' do
        config_file do
          normal 'X', ':RUN', desc: 'DO X', execute: false
        end

        expected = <<-EXPECTED
        " DO X
        nnoremap X :RUN
        EXPECTED

        renders_properly(expected)
      end

      it 'renders simple visual commands(recursively)' do
        config_file do
          visual 'X', ':RUN', desc: 'DO X', recursively: true
        end

        expected = <<-EXPECTED
        " DO X
        xmap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders visual commands with filetype' do
        config_file do
          visual 'X', ':RUN', desc: 'DO X', filetype: :ruby
        end

        expected = <<-EXPECTED
        " DO X
        autocmd FileType ruby xnoremap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end
    end

    context 'Insert commands' do
      it 'renders simple insert commands' do
        config_file do
          insert 'X', ':RUN', desc: 'DO X'
        end

        expected = <<-EXPECTED
        " DO X
        inoremap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders Ruby mappings' do
        config_file do
          insert 'X', desc: 'DO X' do
            puts 'Global'
          end

          insert 'X', desc: 'DO X', filetype: :ruby do
            puts 'For ruby'
          end
        end

        expected = <<-EXPECTED
          " DO X
          inoremap X :call ExecuteRubyMapping('X', 'all')<CR>

          " DO X
          autocmd FileType ruby inoremap X :call ExecuteRubyMapping('X', 'ruby')<CR>
        EXPECTED

        expect(ExecuteRubyMapping.fetch('X', 'ruby')).to respond_to :call
        expect(ExecuteRubyMapping.fetch('X', 'all')).to respond_to :call
        expect(ExecuteRubyMapping.commands.count).to be 2

        renders_properly(expected)
      end

      it 'renders simple insert commands(without executing)' do
        config_file do
          insert 'X', ':RUN', desc: 'DO X', execute: false
        end

        expected = <<-EXPECTED
        " DO X
        inoremap X :RUN
        EXPECTED

        renders_properly(expected)
      end

      it 'renders simple insert commands(recursively)' do
        config_file do
          insert 'X', ':RUN', desc: 'DO X', recursively: true
        end

        expected = <<-EXPECTED
        " DO X
        imap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders insert commands with filetype' do
        config_file do
          insert 'X', ':RUN', desc: 'DO X', filetype: :ruby
        end

        expected = <<-EXPECTED
        " DO X
        autocmd FileType ruby inoremap X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end
    end

    it 'renders prefixes as namespaces' do
      config_file do
        prefix(name: 'NameSpaceX', desc: 'Just a namespace', filetype: :ruby) do
          normal 'C', ':RUN', desc: 'DO C'
        end
      end

      expected = <<-EXPECTED
        " ----------------------------------------------------------------
        " Namespace NameSpaceX
        " Filetype: ruby
        " Just a namespace
        " ----------------------------------------------------------------

        " DO C
        autocmd FileType ruby nnoremap C :RUN<CR>
      EXPECTED

      renders_properly(expected)
    end
  end

  context 'with Prefix' do
    context 'Normal commands' do
      it 'renders simple normal commands' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            normal 'X', ':RUN', desc: 'DO X'
          end
        end

        expected = <<-EXPECTED
          " DO X
          nnoremap pX :RUN<CR>
          call extend(g:which_key_map_sampleprefix, {'X':'DO X'})
        EXPECTED

        renders_properly(expected)
      end

      it 'renders Ruby mappings' do
        config_file do
          prefix('!', name: 'SamplePrefix', desc: 'Does stuff') do
            normal 'X', desc: 'DO X' do
              puts 'Global'
            end

            normal 'X', desc: 'DO X', filetype: :ruby do
              puts 'For ruby'
            end
          end
        end

        expected = <<-EXPECTED
          " DO X
          nnoremap !X :call ExecuteRubyMapping('!X', 'all')<CR>

          " DO X
          autocmd FileType ruby nnoremap !X :call ExecuteRubyMapping('!X', 'ruby')<CR>
        EXPECTED

        expect(ExecuteRubyMapping.fetch('!X', 'ruby')).to respond_to :call
        expect(ExecuteRubyMapping.fetch('!X', 'all')).to respond_to :call
        expect(ExecuteRubyMapping.commands.count).to be 2

        renders_properly(expected)
      end

      it 'renders simple normal commands(without executing)' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            normal 'X', ':RUN', desc: 'DO X', execute: false
          end
        end

        expected = <<-EXPECTED
          " DO X
          nnoremap pX :RUN
          call extend(g:which_key_map_sampleprefix, {'X':'DO X'})
        EXPECTED

        renders_properly(expected)
      end

      it 'renders simple normal commands(recursively)' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            normal 'X', ':RUN', desc: 'DO X', recursively: true
          end
        end

        expected = <<-EXPECTED
        " DO X
        nmap pX :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders normal commands with filetype on the command level' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            normal 'X', ':RUN', desc: 'DO X', filetype: :ruby
          end
        end

        expected = <<-EXPECTED
          " DO X
          autocmd FileType ruby nnoremap pX :RUN<CR>
          autocmd FileType ruby call extend(g:which_key_map_sampleprefix, {'X':'DO X'})
        EXPECTED

        renders_properly(expected)
      end

      it 'renders normal commands with filetype on the prefix level' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff', filetype: :ruby) do
            normal 'X', ':RUN', desc: 'DO X'
          end
        end

        expected = <<-EXPECTED
          " DO X
          autocmd FileType ruby nnoremap pX :RUN<CR>
          autocmd FileType ruby call extend(g:which_key_map_sampleprefix, {'X':'DO X'})
        EXPECTED

        renders_properly(expected)
      end
    end

    context 'Visual commands' do
      it 'renders simple visual commands' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            visual 'X', ':RUN', desc: 'DO X'
          end
        end

        expected = <<-EXPECTED
          " DO X
          xnoremap pX :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders Ruby mappings' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            visual 'X', desc: 'DO X' do
              puts 'Global'
            end

            visual 'X', desc: 'DO X', filetype: :ruby do
              puts 'For ruby'
            end
          end
        end

        expected = <<-EXPECTED
          " DO X
          xnoremap pX :call ExecuteRubyMapping('pX', 'all')<CR>

          " DO X
          autocmd FileType ruby xnoremap pX :call ExecuteRubyMapping('pX', 'ruby')<CR>
        EXPECTED

        puts ExecuteRubyMapping.commands
        expect(ExecuteRubyMapping.fetch('pX', 'ruby')).to respond_to :call
        expect(ExecuteRubyMapping.fetch('pX', 'all')).to respond_to :call
        expect(ExecuteRubyMapping.commands.count).to be 2

        renders_properly(expected)
      end

      it 'renders simple visual commands(without g)' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            visual 'X', ':RUN', desc: 'DO X', execute: false
          end
        end

        expected = <<-EXPECTED
          " DO X
          xnoremap pX :RUN
        EXPECTED

        renders_properly(expected)
      end

      it 'renders simple visual commands(recursively)' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            visual 'X', ':RUN', desc: 'DO X', recursively: true
          end
        end

        expected = <<-EXPECTED
        " DO X
        xmap pX :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders visual commands with filetype on the command level' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff') do
            visual 'X', ':RUN', desc: 'DO X', filetype: :ruby
          end
        end

        expected = <<-EXPECTED
          " DO X
          autocmd FileType ruby xnoremap pX :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders visual commands with filetype on the prefix level' do
        config_file do
          prefix('p', name: 'SamplePrefix', desc: 'Does stuff', filetype: :ruby) do
            visual 'X', ':RUN', desc: 'DO X'
          end
        end

        expected = <<-EXPECTED
          " DO X
          autocmd FileType ruby xnoremap pX :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end
    end

    it 'renders the header properly' do
      config_file do
        prefix(';', name: 'SamplePrefix', desc: 'Does stuff') do
        end
      end

      expected = <<-EXPECTED
        " ----------------------------------------------------------------
        " Prefix SamplePrefix
        " Key ;
        " Does stuff
        " ----------------------------------------------------------------
        let g:which_key_map_sampleprefix = { 'name' : '+SamplePrefix' }
        call which_key#register(';', 'g:which_key_map_sampleprefix')
        nnoremap ; :<c-u>WhichKey ';'<CR>
        vnoremap ; :<c-u>WhichKeyVisual ';'<CR>
      EXPECTED

      renders_properly(expected)
    end

    it 'renders nested prefixes' do
      config_file do
        prefix('a', name: 'SamplePrefix', desc: 'Does stuff') do
          prefix('b', name: 'SampleNestedPrefix', desc: 'Does more stuff') do
            prefix('c', name: 'SampleNestedPrefix', desc: 'Does even more stuff') do
              normal 'D', ':RUN', desc: 'DO C'
            end
          end
        end
      end

      expected = <<-EXPECTED
        " DO C
        nnoremap abcD :RUN<CR>
        call extend(g:which_key_map_sampleprefix['b']['c'], {'D':'DO C'})
      EXPECTED

      renders_properly(expected)
    end
  end

  context 'with Leader' do
    context 'Normal commands' do
      it 'renders simple normal commands' do
        config_file do
          leader('<space>') do
            normal 'X', ':RUN', desc: 'DO X'
          end
        end

        expected = <<-EXPECTED
          " DO X
          nnoremap <leader>X :RUN<CR>
          call extend(g:which_key_map, {'X':'DO X'})
        EXPECTED

        renders_properly(expected)
      end

      it 'renders Ruby mappings' do
        config_file do
          leader('<space>') do
            visual 'X', desc: 'DO X' do
              puts 'Global'
            end

            visual 'X', desc: 'DO X', filetype: :ruby do
              puts 'For ruby'
            end
          end
        end

        expected = <<-EXPECTED
          " DO X
          xnoremap <leader>X :call ExecuteRubyMapping('leaderX', 'all')<CR>

          " DO X
          autocmd FileType ruby xnoremap <leader>X :call ExecuteRubyMapping('leaderX', 'ruby')<CR>
        EXPECTED

        expect(ExecuteRubyMapping.fetch('<leader>X', 'ruby')).to respond_to :call
        expect(ExecuteRubyMapping.fetch('<leader>X', 'all')).to respond_to :call
        expect(ExecuteRubyMapping.commands.count).to be 2

        renders_properly(expected)
      end

      it 'renders normal commands with filetype on the command level' do
        config_file do
          leader('<space>') do
            normal 'X', ':RUN', desc: 'DO X', filetype: :ruby
          end
        end

        expected = <<-EXPECTED
          " DO X
          autocmd FileType ruby nnoremap <leader>X :RUN<CR>
          autocmd FileType ruby call extend(g:which_key_map, {'X':'DO X'})
        EXPECTED

        renders_properly(expected)
      end
    end

    context 'Visual commands' do
      it 'renders simple visual commands' do
        config_file do
          leader('<space>') do
            visual 'X', ':RUN', desc: 'DO X'
          end
        end

        expected = <<-EXPECTED
          " DO X
          xnoremap <leader>X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end

      it 'renders visual commands with filetype on the command level' do
        config_file do
          leader('<space>') do
            visual 'X', ':RUN', desc: 'DO X', filetype: :ruby
          end
        end

        expected = <<-EXPECTED
          " DO X
          autocmd FileType ruby xnoremap <leader>X :RUN<CR>
        EXPECTED

        renders_properly(expected)
      end
    end

    it 'renders the header properly' do
      config_file do
        leader('<space>') do
        end
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
        nnoremap <leader> :<c-u>WhichKey '<leader>'<CR>
        vnoremap <leader> :<c-u>WhichKeyVisual '<leader>'<CR>
      EXPECTED

      renders_properly(expected)
    end

    it 'renders nested prefixes' do
      config_file do
        leader('<space>') do
          prefix('a', name: 'SampleNestedPrefix', desc: 'Does more stuff') do
            prefix('b', name: 'SampleNestedPrefix', desc: 'Does even more stuff') do
              normal 'C', ':RUN', desc: 'DO C'
            end
          end
        end
      end

      expected = <<-EXPECTED
        " DO C
        nnoremap <leader>abC :RUN<CR>
        call extend(g:which_key_map['a']['b'], {'C':'DO C'})
      EXPECTED

      renders_properly(expected)
    end

    it 'renders prefixes as namespaces' do
      config_file do
        prefix('a', name: 'SampleNestedPrefix', desc: 'Does more stuff') do
          prefix(name: 'NameSpaceX', desc: 'Just a namespace', filetype: :ruby) do
            normal 'C', ':RUN', desc: 'DO C'
          end
        end
      end

      expected = <<-EXPECTED
        " ----------------------------------------------------------------
        " Namespace SampleNestedPrefix > NameSpaceX
        " Key a
        " Filetype: ruby
        " Just a namespace
        " ----------------------------------------------------------------

        " DO C
        autocmd FileType ruby nnoremap aC :RUN<CR>
        autocmd FileType ruby call extend(g:which_key_map_samplenestedprefix, {'C':'DO C'})
      EXPECTED

      renders_properly(expected)
    end
  end

  def config_file(&block)
    VimMappingManager.call(&block)
  end

  def renders_properly(expected)
    VimMappingManager.render

    actual = OutputFile.output

    # Helps on debuging
    path = File.expand_path('./last_render_spec.vimrc')
    File.open(path, 'w+') { |file| file.write(actual) }

    actual = actual.gsub(/^ +/, '')
    expected = expected.gsub(/^ +/, '')

    expect(actual.lines).to include(*expected.lines)
  end
end
