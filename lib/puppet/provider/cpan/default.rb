Puppet::Type.type(:cpan).provide(:cpan) do
  @doc = "Manages cpan modules"

  confine :feature => :posix
  commands :cpan => 'cpan'

  def install
    result = nil
    unless run( "perl -M" + resource[:name] + " -e1" )
      result = cpan( "install", resource[:name] )
    else
      result = resource[:name] + " already installed"
    end
    result
  end

  def force
    cpan( "-fi", resource[:name] )
  end
end
