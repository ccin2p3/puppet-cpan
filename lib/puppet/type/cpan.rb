Puppet::Type.newtype(:cpan) do
  ensurable do
    desc "cpan module, :present, :force"

    newvalue(:present) do
      provider.install
    end

    newvalue(:force) do
      provider.force
    end
  end

  autorequire(:package) do
    'cpan'
  end
end
