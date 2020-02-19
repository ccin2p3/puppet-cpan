require 'spec_helper'

described_type = Puppet::Type.type(:cpan)

describe 'cpan' do
  let(:title) { 'baz' }

  describe 'force' do
    it 'rejects other values (rspec)' do
      expect { described_type.new(name: 'test', force: 'nope') }.to raise_error(Puppet::Error)
    end
    it 'rejects other values (be_valid_type)' do
      expect {be_valid_type.with_set_attributes({:force => 'nope'})}.to raise_error(Puppet::Error)
    end
  end
end
