Puppet::Type.type(:cpan).provide(:default) do
  @doc = 'Manages cpan modules'

  commands cpan: 'cpan'
  commands perl: 'perl'
  confine  osfamily: [:Debian, :RedHat, :Windows]
  ENV['PERL_MM_USE_DEFAULT'] = '1'

  def install; end

  def force; end

  def latest?
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end
    current_version = `perl #{ll} -M#{resource[:name]} -e 'print $#{resource[:name]}::VERSION'`
    cpan_str = `perl #{ll} -e 'use CPAN; my $mod=CPAN::Shell->expand("Module","#{resource[:name]}"); \
                printf("%s", $mod->cpan_version eq "undef" || !defined($mod->cpan_version) ? "-" : $mod->cpan_version);'`
    latest_version = cpan_str.match(%r{^[0-9]+.?[0-9]*$})[0]
    current_version.chomp
    latest_version.chomp
    if current_version < latest_version
      return false
    end
    true
  end

  def create
    Puppet.info("Installing cpan module #{resource[:name]}")
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end

    umask = "umask #{resource[:umask]};" if resource[:umask]
    if resource[:environment]
      resource[:environment].each do |var, val|
        ENV[var] = val
      end
    end

    Puppet.debug("cpan #{resource[:name]}")
    if resource.force?
      Puppet.info("Forcing install for #{resource[:name]}")
      system("#{umask} yes | perl #{ll} -MCPAN -e 'CPAN::Shell->force(qw(install #{resource[:name]}))'")
    else
      system("#{umask} yes | perl #{ll} -MCPAN -e 'CPAN::install #{resource[:name]}'")
    end

    exists_command = case resource[:exists_strategy]
                     when :find
                       # stolen from pmtools/pmpath
                       # will not work on windows
                       # use Module::Find maybe instead
                       "perl #{ll} -e '$module=#{resource[:name]}; eval \"local \\$^W = 0; require $module\";for ($shortpath = $module) {s{::}{/}g;s/$/.pm/;} \
                                              if (defined($INC{$shortpath})) {exit 0;}; exit 2'"
                     else
                       "perl #{ll} -M#{resource[:name]} -e1 > /dev/null 2>&1"
                     end
    system(exists_command)
    estatus = $CHILD_STATUS.exitstatus

    raise Puppet::Error, "cpan #{resource[:name]} failed with error code #{estatus}" if estatus != 0
  end

  def destroy; end

  def update
    Puppet.info("Upgrading cpan module #{resource[:name]}")
    Puppet.debug("cpan #{resource[:name]}")
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end
    umask = "umask #{resource[:umask]};" if resource[:umask]
    if resource[:environment]
      resource[:environment].each do |var, val|
        ENV[var] = val
      end
    end

    if resource.force?
      Puppet.info("Forcing upgrade for #{resource[:name]}")
      system("#{umask} yes | perl #{ll} -MCPAN -e 'CPAN::Shell->force(qw(install #{resource[:name]}))'")
    else
      system("#{umask} yes | perl #{ll} -MCPAN -e 'CPAN::install #{resource[:name]}'")
    end
    estatus = $CHILD_STATUS.exitstatus

    raise Puppet::Error, "CPAN::install #{resource[:name]} failed with error code #{estatus}" if estatus != 0
  end

  def exists?
    if resource[:local_lib]
      ll = "-Mlocal::lib=#{resource[:local_lib]}"
    end
    exists_command = case resource[:exists_strategy]
                     when :find
                       # stolen from pmtools/pmpath
                       # will not work on windows
                       # use Module::Find maybe instead
                       "perl #{ll} -e '$module=#{resource[:name]}; eval \"local \\$^W = 0; require $module\";for ($shortpath = $module) {s{::}{/}g;s/$/.pm/;} \
                                                    if (defined($INC{$shortpath})) {exit 0;}; exit 2'"
                     else
                       "perl #{ll} -M#{resource[:name]} -e1 > /dev/null 2>&1"
                     end
    Puppet.debug(exists_command)
    output = `#{exists_command}`
    estatus = $CHILD_STATUS.exitstatus

    case estatus
    when 0
      true
    when 2
      Puppet.debug("#{resource[:name]} not installed")
      false
    else
      raise Puppet::Error, "exists_command `#{exists_command}` failed with error code #{estatus}: #{output}"
    end
  end
end
