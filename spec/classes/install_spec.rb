require 'spec_helper'

describe "cpan::install" do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      describe 'package_ensure and manage_package' do
        let(:pre_condition) do
          [
            'class { "cpan":
               package_ensure => "present", 
               manage_package => true,
               local_lib      => false,
            }
            ',
          ]
        end

        it { is_expected.to contain_package('gcc').with(:ensure => 'present') }
        it { is_expected.to contain_package('make').with(:ensure => 'present') }

        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_package('perl').with(:ensure => 'present') }
        when 'RedHat'
          it { is_expected.to contain_package('perl-CPAN').with(:ensure => 'present') }
        end
      end
      describe 'should allow package ensure to be overridden' do
        let(:pre_condition) do
          [
            'class { "cpan":
               package_ensure => "latest", 
               manage_package => true,
            }
            ',
          ]
        end
        it { is_expected.to contain_package('gcc').with_ensure('latest') }
        it { is_expected.to contain_package('make').with_ensure('latest') }
        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_package('perl').with(:ensure => 'latest') }
        when 'RedHat'
          it { is_expected.to contain_package('perl-CPAN').with(:ensure => 'latest') }
        end
      end
    end
  end
end
