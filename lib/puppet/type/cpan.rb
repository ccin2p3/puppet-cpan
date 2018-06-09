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
        provider.create
      end
    end
  end

  newparam(:name) do
    desc 'The name of the module.'
  end

  newparam(:local_lib) do
    desc 'Destination directory or `false`'
  end

  newparam(:force, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc 'Enable/Disable to force the installation of the module. Disabled by default.'
    defaultto :false
  end

  newparam(:umask) do
    desc 'umask to run cpan with'
    validate do |value|
      raise ArgumentError, 'string expected for umask' unless value.is_a?(String)
      raise ArgumentError, 'umask should be a 3 or 4 character octal string' unless value =~ /^[0-7]{3,4}$/
    end
  end
end
