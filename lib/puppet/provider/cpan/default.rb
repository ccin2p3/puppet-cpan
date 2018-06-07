Puppet::Type.type(:cpan).provide(:default) do
  @doc     = 'Manages cpan modules'
  @ll      = "-Mlocal::lib=#{resource[:local_lib]}" if resource[:local_lib]
  @umask   = "umask #{resource[:umask]};" if resource[:umask]
  @current = `perl #{ll} -M#{resource[:name]} -e 'print $#{resource[:name]}::VERSION' 2>/dev/null;`
  @force   = resource.force? ? 'CPAN::force' : ''

  commands cpan: 'cpan'
  commands perl: 'perl'
  confine  osfamily: %i[Debian DragonFly FreeBSD RedHat Windows]
  ENV['PERL_MM_USE_DEFAULT'] = '1'

  def install; end

  def force; end

  def latest?
    return false if current == ''
    cpan_str = `perl #{ll} -e 'use CPAN; my $mod=CPAN::Shell->expand("Module","#{resource[:name]}"); printf("%s", $mod->cpan_version eq "undef" || !defined($mod->cpan_version) ? "-" : $mod->cpan_version);'`
    latest   = cpan_str.match(/^[a-zA-Z]?([0-9]+.?[0-9]*\.?[0-9]*)$/)[1]
    if Puppet::Util::Package.versioncmp(latest.chomp, current.chomp) > 0
      return true
    end
    false
  end

  def create
    Puppet.info("Installing cpan module #{resource[:name]}")
    system("#{umask} yes | perl #{ll} -MCPAN -e '#{force} CPAN::install #{resource[:name]}'")
    raise Puppet::Error, "cpan #{resource[:name]} failed" unless exists?
  end

  def destroy; end

  def exists?
    Puppet.debug("perl #{ll} -M#{resource[:name]} -e1 > /dev/null 2>&1")
    output  = `perl #{ll} -M#{resource[:name]} -e1 > /dev/null 2>&1`
    estatus = $CHILD_STATUS.exitstatus

    case estatus
    when 0
      return true
    when 2
      return false
    end
    raise Puppet::Error, "perl #{ll} -M#{resource[:name]} -e1 failed: #{estatus} #{output}"
  end
end
