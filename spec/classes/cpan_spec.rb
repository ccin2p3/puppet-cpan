require 'spec_helper'

describe 'cpan', :type => 'class' do
  let(:facts) { {} }
  ['Debian', 'RedHat'].each do |system|
    context "On a #{system} OS ..." do
      if system == 'Debian'
        let(:facts) { super().merge(
            :operatingsystem           => system,
            :osfamily                  => system,
            :operatingsystemmajrelease => '6',
            :path                      => '/usr/local/bin:/usr/bin:/bin',
          )
        }
      end

      if system == 'RedHat'
        let(:facts) { super().merge(
            :osfamily                  => system,
            :operatingsystem           => system,
            :operatingsystemmajrelease => '6',
            :path                      => '/usr/local/bin:/usr/bin:/bin',
          )
        }
      end

      it { should contain_class('cpan::install') }
      it { should contain_class('cpan::config') }

      describe "cpan::install" do
        let(:params) { {:package_ensure => 'present', :manage_package => true, :local_lib => false} }

        it { should contain_package('gcc').with(:ensure => 'present') }
        it { should contain_package('make').with(:ensure => 'present') }

        if system == 'Debian'
          it { should contain_package('perl-modules').with(:ensure => 'present') }
        end

        if system == 'RedHat'
          it { should contain_package('perl-CPAN').with(:ensure => 'present') }
        end

        describe 'should allow package ensure to be overridden' do
          let(:params) { {:package_ensure => 'latest', :manage_package => true} }
          it { should contain_package('gcc').with_ensure('latest') }
          it { should contain_package('make').with_ensure('latest') }
          if system == 'Debian'
            it { should contain_package('perl-modules').with(:ensure => 'latest') }
          end
          if system == 'RedHat'
            it { should contain_package('perl-CPAN').with(:ensure => 'latest') }
          end
        end
      end
    end

    context 'cpan::config' do

      describe "cpan::config on Debian" do
        let(:facts) { super().merge(:osfamily => 'Debian') }
        it { should contain_file('/etc/perl/CPAN/Config.pm').with_owner('root') }
        it { should contain_file('/etc/perl/CPAN/Config.pm').with_group('root') }
        it { should contain_file('/etc/perl/CPAN/Config.pm').with_mode('0644') }
      end

      describe 'cpan::config on RedHat and operatingsystemrelease 6' do
        let(:facts) { super().merge(:osfamily => 'RedHat', :operatingsystemmajrelease => '6') }
        it { should contain_file('/usr/share/perl5/CPAN/Config.pm').with_owner('root') }
        it { should contain_file('/usr/share/perl5/CPAN/Config.pm').with_group('root') }
        it { should contain_file('/usr/share/perl5/CPAN/Config.pm').with_mode('0644') }
      end

      describe 'cpan::config on RedHat and operatingsystemrelease 7' do
        let(:facts) { super().merge(:osfamily => 'RedHat', :operatingsystemmajrelease => '7') }
        it { should contain_file('/usr/share/perl5/CPAN/Config.pm').with_owner('root') }
        it { should contain_file('/usr/share/perl5/CPAN/Config.pm').with_group('root') }
        it { should contain_file('/usr/share/perl5/CPAN/Config.pm').with_mode('0644') }
      end

      describe 'cpan::config on RedHat and operatingsystemrelease 5' do
        let(:facts) { super().merge(:osfamily => 'RedHat', :operatingsystemmajrelease => '5') }
        it { should contain_file('/usr/lib/perl5/5.8.8/CPAN/Config.pm').with_owner('root') }
        it { should contain_file('/usr/lib/perl5/5.8.8/CPAN/Config.pm').with_group('root') }
        it { should contain_file('/usr/lib/perl5/5.8.8/CPAN/Config.pm').with_mode('0644') }
      end

      describe "for operating system family unsupported" do
        let(:facts) { super().merge(:osfamily => 'unsupported') }
        it { expect {catalogue}.to raise_error(
          /Module cpan is not supported/
        ) }
      end
    end
  end
end
