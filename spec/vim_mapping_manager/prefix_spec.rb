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
        prefix 'r', name: 'Rails', desc: 'Search in Rails directories' do
          normal 'mo', ':Files <cr> app/models/', desc: 'Find for models'
          normal 'co', ':Files <cr> app/controllers/', desc: 'Find for controllers'
        end
      end

      a
    end

    specify do
      expected = <<-EXPECTED
        asdf
      EXPECTED

      subject.render
      renders_properly(OutputFile.output, expected)
    end

    def renders_properly(actual, expected)
      actual = actual
      expected = expected.gsub(/^ */, '').chomp
      expect(actual).to include(expected)
    end
  end
end
