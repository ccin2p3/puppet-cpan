Puppet::Type.newtype(:cpan) do
  @doc = "Install cpan modules"
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
  end

  newparam(:name) do
    desc "The name of the module."
  end
  newparam(:local_lib) do
    desc "Destination directory or `false`"
  end
  #newparam(:force, :boolean => true, :parent => Puppet::Parameter::Boolean) do
  newparam(:force, :boolean => true) do
  desc "Enable/Disable to force the installation of the module. Disabled by default."
  defaultto :false
  end
end
