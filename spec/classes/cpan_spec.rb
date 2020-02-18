require 'spec_helper'

describe 'cpan' do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('cpan::install') }
      it { is_expected.to contain_class('cpan::config') }

      describe 'cpan::install' do
        let(:params) { { package_ensure: 'present', manage_package: true, local_lib: false } }

        it { is_expected.to contain_package('gcc').with(ensure: 'present') }
        it { is_expected.to contain_package('make').with(ensure: 'present') }

        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_package('perl').with(ensure: 'present') }
        when 'RedHat'
          it { is_expected.to contain_package('perl-CPAN').with(ensure: 'present') }
        end

        describe 'should allow package ensure to be overridden' do
          let(:params) { { package_ensure: 'latest', manage_package: true } }

          it { is_expected.to contain_package('gcc').with_ensure('latest') }
          it { is_expected.to contain_package('make').with_ensure('latest') }
          case os_facts[:osfamily]
          when 'Debian'
            it { is_expected.to contain_package('perl').with(ensure: 'latest') }
          when 'RedHat'
            it { is_expected.to contain_package('perl-CPAN').with(ensure: 'latest') }
          end
        end
      end
    end
  end
  context 'for operating system family unsupported' do
    let(:facts) do
      {
        osfamily: 'unsupported',
      }
    end

    it { expect { is_expected.to compile }.to raise_error(%r{Module cpan is not supported}) }
  end
end
