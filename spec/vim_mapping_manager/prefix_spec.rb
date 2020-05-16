RSpec.describe Prefix do
  before do
    OutputFile.reset!
    VimMappingManager.reset!
  end

  describe '#render' do
    let(:key_stroke) { KeyStroke.new(';') }

    subject do
      described_class.new('FuzzyFinder', key_stroke, desc: 'Search everything')
    end

    specify do
      expected = <<-EXPECTED
       " ----------------------------------------------------------------
       " Prefix: FuzzyFinder, key: ;
       " Search everything
       " ----------------------------------------------------------------
       nnoremap  [FuzzyFinder] <Nop>
       nmap      ; [Files]
      EXPECTED

      renders_properly(subject.render, expected)
    end

    def renders_properly(actual, expected)
      actual = actual.gsub(/^ */, '').chomp
      expected = expected.gsub(/^ */, '').chomp
      expect(actual).to include(expected)
    end
  end
end
