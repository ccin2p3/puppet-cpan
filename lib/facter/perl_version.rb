Facter.add(:perl) do
  setcode do
    perl = {}
    current_info = Facter::Util::Resolution.exec('perl -v')
    version = current_info.match(/v((\d+)\.(\d+)\.(\d*))/)
    Facter.debug "Matching perl version as #{version}"
    perl['version'] = version[1]
    perl['majversion'] = version[2]
    perl['minversion'] = version[3]
    perl['subversion'] = version[4]
    perl
  end
end
