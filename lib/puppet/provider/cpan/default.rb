Puppet::Type.type(:cpan).provide( :default ) do
  @doc = "Manages cpan modules"

  commands :cpan     => 'cpan'
  commands :perl     => 'perl'
  confine  :osfamily => [:Debian, :RedHat, :Windows]
  ENV['PERL_MM_USE_DEFAULT'] = '1'

  def install
  end

  def force
  end

  def latest?
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end
    current_version=`perl #{ll} -M#{resource[:name]} -e 'print $#{resource[:name]}::VERSION'`
    cpan_str=`perl #{ll} -e 'use CPAN; my $mod=CPAN::Shell->expand("Module","#{resource[:name]}"); printf("%s", $mod->cpan_version eq "undef" || !defined($mod->cpan_version) ? "-" : $mod->cpan_version);'`
    latest_version=cpan_str.match(/^[0-9]+.?[0-9]*$/)[0]
    current_version.chomp
    latest_version.chomp
    if current_version < latest_version
    return false else return true end
  end

  def create
    Puppet.info("Installing cpan module #{resource[:name]}")
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end

    Puppet.debug("cpan #{resource[:name]}")
    if resource[:force] == false then
      system("yes | perl #{ll} -MCPAN -e 'CPAN::install #{resource[:name]}'")
    else
      Puppet.info("Forcing install for #{resource[:name]}")
      system("yes | perl #{ll} -MCPAN -e 'CPAN::force CPAN::install #{resource[:name]}'")
    end

    #cpan doesn't always provide the right exit code, so we double check
    system("perl #{ll} -M#{resource[:name]} -e1 > /dev/null 2>&1")
    estatus = $?.exitstatus

    if estatus != 0
      raise Puppet::Error, "cpan #{resource[:name]} failed with error code #{estatus}"
    end
  end

  def destroy
  end
  
  def update
    Puppet.info("Upgrading cpan module #{resource[:name]}")
    Puppet.debug("cpan #{resource[:name]}")
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end
    if resource[:force] == false then
          system("yes | perl #{ll} -MCPAN -e 'CPAN::install #{resource[:name]}'")
    else
      Puppet.info("Forcing upgrade for #{resource[:name]}")
      system("yes | perl #{ll} -MCPAN -e 'CPAN::force CPAN::install #{resource[:name]}'")
    end
    estatus = $?.exitstatus
    
    if estatus != 0
      raise Puppet::Error, "CPAN::install #{resource[:name]} failed with error code #{estatus}"
    end
  end

  def exists?
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end
    Puppet.debug("perl #{ll} -M#{resource[:name]} -e1 > /dev/null 2>&1")
    output = `perl #{ll} -M#{resource[:name]} -e1 > /dev/null 2>&1`
    estatus = $?.exitstatus

    case estatus
    when 0
      true
    when 2
      Puppet.debug("#{resource[:name]} not installed")
      false
    else
      raise Puppet::Error, "perl #{ll} -M#{resource[:name]} -e1 failed with error code #{estatus}: #{output}"
    end
  end

end
