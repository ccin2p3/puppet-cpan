Puppet::Type.type(:cpan).provide( :default ) do
  @doc = "Manages cpan modules"

  commands :cpan => '/usr/bin/cpan'
  commands :perl => '/usr/bin/perl'

  def install
  end

  def force
  end

  def create
    Puppet.info("Installing cpan module #{resource[:name]}. This can take awhile.")

    system("/usr/bin/cpan #{resource[:name]} > /dev/null 2>&1")
    estatus = $?.exitstatus

    if estatus != 0
      raise Puppet::Error, "/usr/bin/cpan #{resource[:name]} failed with error code #{estatus}"
    end
  end

  def destroy
  end

  def exists?
    Puppet.debug("perl -M#{resource[:name]} -e1 > /dev/null 2>&1")
    output = system("/usr/bin/perl -M#{resource[:name]} -e1 > /dev/null 2>&1")
    estatus = $?.exitstatus

    case estatus
    when 0
      true
    when 2
      Puppet.debug("#{resource[:name]} not installed. Installing..")
      false
    else
      raise Puppet::Error, "/usr/bin/perl -M#{resource[:name]} -e1 failed with error code #{estatus}: #{output}"
    end
  end

end
