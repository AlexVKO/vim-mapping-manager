RSpec.describe NormalCommand do
  before do
    OutputFile.reset!
    VimMappingManager.reset!
  end

  describe '#render' do
    let(:key_stroke) { KeyStroke.new('du') }

    subject do
      described_class.new(':saveas <C-R>=expand('%')<CR>', key_stroke, desc: 'Duplicate current file')
    end

    specify do
      expected = <<-EXPECTED
      " Duplicate current file
      nnoremap du :saveas <C-R>=expand('%')<CR>
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

