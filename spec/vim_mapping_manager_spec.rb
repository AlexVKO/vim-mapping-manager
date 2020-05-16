RSpec.describe VimMappingManager do
  it "has a version number" do
    expect(VimMappingManager::VERSION).not_to be "0.1.0"
  end

  describe 'Simple mapping' do
    it 'renders prefixes' do
      described_class.prefix(';', name: 'FuzzyFinder', desc: 'Search everything') do
        # normal('du', ":saveas #{current_file_path}", desc: "Duplicate current file")
      end

      expected = <<-EXPECTED
       " -----------------------------------------------------------------------------
       " Prefix: FuzzyFinder, key: ;
       " Search everything
       " -----------------------------------------------------------------------------
       nnoremap  [FuzzyFinder] <Nop>
       nmap      ; [Files]
      EXPECTED

      renders_properly(described_class.render, expected)
    end

    it 'renders normal mode mappings'  do
      described_class.normal('du', ":saveas #{current_file_path}", desc: "Duplicate current file")

      expected = <<-EXPECTED
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

# global.key_stroke('w')
# KeyStroke<key='w', normal_command: nil, edit_command: nil>
# global.key_stroke('w').key_stroke('du').normal_command(':saveas #{current_file_path}#{open_command_line_window}')
