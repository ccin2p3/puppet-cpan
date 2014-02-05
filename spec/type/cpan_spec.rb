require 'spec_helper'

describe Puppet::Type.type(:cpan) do
  before :each do
    @provider_class = described_class.provide(:simple) do
      mk_resource_methods
      def create; end
      def delete; end
      def exists?; get(:ensure) != :absent; end
    end
    described_class.stub(:defaultprovider).and_return @provider_class
  end

  it "should be able to create an instance" do
    described_class.new(:name => 'LWP').should_not be_nil
  end
end
