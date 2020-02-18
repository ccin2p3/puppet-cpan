require 'spec_helper'

described_type = Puppet::Type.type(:cpan)

describe 'cpan' do
  let(:title) { 'baz' }

  describe 'valid type' do
    it { is_expected.to be_valid_type }
  end
  describe 'ensure' do
    [:present, :absent, :installed, :latest].each do |value|
      it "accepts #{value} as a value" do
        is_expected.to be_valid_type.with_set_attributes(ensure: value)
      end
    end
    it 'rejects other values' do
      expect { described_type.new(name: 'test', ensure: 'foo') }.to raise_error(Puppet::Error)
    end
  end

  describe 'name' do
    it 'is the namevar' do
      expect(described_type.key_attributes).to eq([:name])
    end
  end

  describe 'local_lib' do
    it 'accepts an absolute path' do
      is_expected.to be_valid_type.with_set_attributes(local_lib: '/path/to/file')
    end
    it 'accepts false' do
      is_expected.to be_valid_type.with_set_attributes(local_lib: false)
    end
  end

  describe 'force' do
    [true, false, 'true', 'false', 'no', 'yes'].each do |value|
      it "accepts #{value}" do
        is_expected.to be_valid_type.with_set_attributes(force: value)
      end
    end
    it 'rejects other values' do
      # for some reason expect { be_valid_type.with_set_attributes({:force => 'nope'})}.to raise_error doesn't raise
      # expect {be_valid_type.with_set_attributes({:force => 'nope'})}.to raise_error(Puppet::ResourceError)
      expect { described_type.new(name: 'test', force: 'nope') }.to raise_error(Puppet::Error)
    end
    it 'defaults to false' do
      expect(described_type.new(name: 'test')[:force]).to eq(false)
    end
    it 'munges \'false\' to false' do
      expect(described_type.new(name: 'test', force: 'false')[:force]).to eq(false)
    end
    it 'munges \'true\' to true' do
      expect(described_type.new(name: 'test', force: 'true')[:force]).to eq(true)
    end
  end

  describe 'umask' do
    describe 'valid values' do
      ['0022', '022', '0027', '027'].each do |value|
        it "accepts #{value}" do
          is_expected.to be_valid_type.with_set_attributes(umask: value)
        end
      end
    end
    describe 'invalid values' do
      [true, false, 220, '0', '888', 'invalid'].each do |value|
        it "rejects #{value}" do
          expect { described_type.new(name: 'test', umask: value) }.to raise_error(Puppet::Error)
        end
      end
    end
  end
end
