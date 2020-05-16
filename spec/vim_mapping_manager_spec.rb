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
        normal('<leader>e', 'gg=G<C-O>', desc: 'indent current file')

        prefix(',', name: 'Files', desc: 'Mappings related to file manipulation') do
          normal('du', ":saveas #{current_file_path}", desc: "Duplicate current file")
          normal('ct', ':checktime',                   desc: 'Reload the file')
          normal('de', ':!rm %',                       desc: 'Delete current file')
        end
      end

      expected = <<-EXPECTED
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
      EXPECTED

      renders_properly(described_class.render, expected)
    end

    def renders_properly(actual, expected)
      actual = actual.gsub(/^ */, '')
      expected = expected.gsub(/^ */, '')
      expect(actual).to include(expected)
    end
  end
end
