require 'puppet/parameter/boolean'

Puppet::Type.newtype(:cpan) do
  @doc = 'Install cpan modules'
  ensurable do
    newvalue(:absent) do
      if provider.exists?
        provider.destroy
      end
    end

    newvalue(:present) do
      unless provider.exists?
        provider.create
      end
    end
    aliasvalue(:installed, :present)

    newvalue(:latest) do
      unless provider.latest?
        provider.update
      end
    end

    def insync?(is)
      @should ||= []
      if is == :absent
        provider.create
      end
      if should == :present
        return true unless [:absent, :purged, :held].include?(is)
      end
      if should == :latest
        if provider.latest?
          return true
        end
        debug 'CPAN Module %s version is out of date, installed version: %s, latest version: %s' %
          [
	    @resource.name,
            provider.version,
            provider.latest
          ]
        return false
      end
    end
  end

  newparam(:name) do
    desc 'The name of the module.'
  end

  newparam(:local_lib) do
    desc 'Destination directory or `false`'
  end

  newparam(:environment) do
    desc 'List of environment variables in the form of a Hash'
    validate do |value|
      raise ArgumentError, 'Hash expected for environment' unless value.is_a?(Hash)
    end
  end

  newparam(:exists_strategy) do
    defaultto 'include'
    newvalues('include', 'find')
    desc 'Strategy to test for module existence'
  end

  newparam(:force, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Enable/Disable to force the installation of the module. Disabled by default.'
    defaultto :false
  end

  newparam(:umask) do
    desc 'umask to run cpan with'
    validate do |value|
      raise ArgumentError, 'string expected for umask' unless value.is_a?(String)
      raise ArgumentError, 'umask should be a 3 or 4 character octal string' unless value =~ %r{^[0-7]{3,4}$}
    end
  end
end
