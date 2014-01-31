Puppet::Type.newtype(:cpan) do
  @doc = "Install cpan modules"
  ensurable

  newparam(:name) do
    desc "The name of the module."
  end

end
