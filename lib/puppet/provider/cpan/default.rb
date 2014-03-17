Puppet::Type.type(:cpan).provide( :default ) do
  @doc = "Manages cpan modules"

  commands :cpan     => 'cpan'
  commands :perl     => 'perl'
  confine  :osfamily => [:Debian, :RedHat]

  def install
  end

  def force
  end

  def create
    Puppet.info("Installing cpan module #{resource[:name]}")

    Puppet.debug("cpan #{resource[:name]}")
    system("cpan #{resource[:name]}")

    #cpan doesn't always provide the right exit code, so we double check
    system("perl -M#{resource[:name]} -e1 > /dev/null 2>&1")
    estatus = $?.exitstatus

    if estatus != 0
      raise Puppet::Error, "cpan #{resource[:name]} failed with error code #{estatus}"
    end
  end

  def destroy
  end

  def exists?
    Puppet.debug("perl -M#{resource[:name]} -e1 > /dev/null 2>&1")
    output = `perl -M#{resource[:name]} -e1 > /dev/null 2>&1`
    estatus = $?.exitstatus

    case estatus
    when 0
      true
    when 2
      Puppet.debug("#{resource[:name]} not installed")
      false
    else
      raise Puppet::Error, "perl -M#{resource[:name]} -e1 failed with error code #{estatus}: #{output}"
    end
  end

end
