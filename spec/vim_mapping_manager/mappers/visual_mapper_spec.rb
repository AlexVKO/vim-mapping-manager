RSpec.describe Mappers::Visual do
  before do
    OutputFile.reset!
    VimMappingManager.reset!
  end

  describe '#render' do
    let(:key_stroke) { KeyStroke.new('du') }

    subject do
      described_class.new(":saveas <C-R>=expand('%')<CR>", key_stroke, desc: 'Duplicate current file')
    end

    specify do
      expected = <<-EXPECTED
       " Duplicate current file
       xnoremap <silent> du :saveas <C-R>=expand('%')<CR>
      EXPECTED

      subject.render
      renders_properly(OutputFile.output, expected)
    end

    def renders_properly(actual, expected)
      actual = actual.gsub(/^ */, '').strip.chomp
      expected = expected.gsub(/^ */, '').strip.chomp
      expect(actual).to include(expected)
    end
  end
end

