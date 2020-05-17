RSpec.describe Prefix do
  before do
    OutputFile.reset!
    VimMappingManager.reset!
  end

  describe '#render' do
    let(:key_stroke) { KeyStroke.new(';') }

    subject do
      a = described_class.new('FuzzyFinder', key_stroke, desc: 'Search everything')

      a.instance_exec do
        prefix 'r', name: 'Search in the project', desc: 'Search in Rails directories' do
          normal 'mo', ':Files <cr> models', desc: 'Find for models'
        end

        prefix 'r', name: 'Search in the project', desc: 'Search in Rails directories', filetype: :ruby do
          normal 'mo', ':Files <cr> app/models/', desc: 'Find for models'
        end

        prefix 'r', name: 'Search in the project', desc: 'Search in Rails directories', filetype: :elixir do
          normal 'mo', ':Files <cr> lib/models/', desc: 'Find for models'
        end
      end

      a
    end

    specify 'properly renders' do
      expected = <<-EXPECTED
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
        " Prefix FuzzyFinder > Search in the project
        " Key ;r
        " Search in Rails directories
        " ----------------------------------------------------------------
        let g:which_key_map_fuzzyfinder.r = { 'name' : '+FuzzyFinder > Search in the project' }

        " Find for models
        nnoremap <silent> ;rmo :Files <cr> models
        call extend(g:which_key_map_fuzzyfinder.r, {'mo':'Find for models'})


        " ----------------------------------------------------------------
        " Prefix FuzzyFinder > Search in the project
        " Key ;r
        " Filetype: ruby
        " Search in Rails directories
        " ----------------------------------------------------------------
        let g:which_key_map_fuzzyfinder.r = { 'name' : '+FuzzyFinder > Search in the project' }

        " Find for models
        autocmd FileType ruby nnoremap <silent> ;rmo :Files <cr> app/models/
        autocmd FileType ruby call extend(g:which_key_map_fuzzyfinder.r, {'mo':'Find for models'})


        " ----------------------------------------------------------------
        " Prefix FuzzyFinder > Search in the project
        " Key ;r
        " Filetype: elixir
        " Search in Rails directories
        " ----------------------------------------------------------------
        let g:which_key_map_fuzzyfinder.r = { 'name' : '+FuzzyFinder > Search in the project' }

        " Find for models
        autocmd FileType elixir nnoremap <silent> ;rmo :Files <cr> lib/models/
        autocmd FileType elixir call extend(g:which_key_map_fuzzyfinder.r, {'mo':'Find for models'})
      EXPECTED

      subject.render
      renders_properly(OutputFile.output, expected)
    end

    def renders_properly(actual, expected)
      expected = expected.gsub(/      /, '')
      expect(actual.lines).to include(*expected.lines)
    end
  end
end
