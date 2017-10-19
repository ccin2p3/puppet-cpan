describe Puppet::Type.type(:cpan) do
  describe 'ensure' do
    %i[present absent installed latest].each do |value|
      it "accepts #{value} as a value" do
        expect { described_class.new(name: 'test', ensure: value) }.not_to raise_error
      end
    end
    it 'rejects other values' do
      expect { described_class.new(name: 'test', ensure: 'foo') }.to raise_error(Puppet::Error)
    end
  end
  describe 'name' do
    it 'is the namevar' do
      expect(described_class.key_attributes).to eq([:name])
    end
  end
  describe 'local_lib' do
    it 'accepts an absolute path' do
      expect { described_class.new(name: 'test', local_lib: '/path/to/file') }.not_to raise_error
    end
    it 'accepts false' do
      expect { described_class.new(name: 'test', local_lib: false) }.not_to raise_error
    end
  end
  describe 'force' do
    [true, false, 'true', 'false', 'no', 'yes'].each do |value|
      it "accepts #{value}" do
        expect { described_class.new(name: 'test', force: value) }.not_to raise_error
      end
    end
    it 'rejects other values' do
      expect { described_class.new(name: 'test', force: 'nope') }.to raise_error(Puppet::Error)
    end
    it 'defaults to false' do
      expect(described_class.new(name: 'test')[:force]).to eq(false)
    end
    it 'munges \'false\' to false' do
      expect(described_class.new(name: 'test', force: 'false')[:force]).to eq(false)
    end
    it 'munges \'true\' to true' do
      expect(described_class.new(name: 'test', force: 'true')[:force]).to eq(true)
    end
  end
end
