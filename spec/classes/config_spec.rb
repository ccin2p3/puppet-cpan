require 'spec_helper'

describe 'cpan::config' do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }

      context 'With default ::cpan parameters' do
        let(:pre_condition) do
          [
            'include cpan',
          ]
        end

        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_file('/etc/perl/CPAN/Config.pm').with_owner('root') }
          it { is_expected.to contain_file('/etc/perl/CPAN/Config.pm').with_group('root') }
          it { is_expected.to contain_file('/etc/perl/CPAN/Config.pm').with_mode('0644') }
        when 'RedHat'
          case os_facts[:os]['release']['major']
          when '5'
            it {
              is_expected.to contain_file('/usr/lib/perl5/5.8.8/CPAN/Config.pm').with_owner('root')
              is_expected.to contain_file('/usr/lib/perl5/5.8.8/CPAN/Config.pm').with_group('root')
              is_expected.to contain_file('/usr/lib/perl5/5.8.8/CPAN/Config.pm').with_mode('0644')
            }
          when '6'
            it {
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_owner('root')
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_group('root')
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_mode('0644')
            }
          when '7'
            it {
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_owner('root')
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_group('root')
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_mode('0644')
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_content(%r{^  'http_proxy' => q\[\],$})
              is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_content(%r{^  'ftp_proxy' => q\[\],$})
            }
            it 'has empty urlist' do
              verify_contents(catalogue, '/usr/share/perl5/CPAN/Config.pm', [
                                "  'urllist' => [",
                                '  ],',
                              ])
            end
          end
        end
      end
      context 'With custom ::cpan parameters' do
        case os_facts[:osfamily]
        when 'RedHat'
          case os_facts[:os]['release']['major']
          when '7'
            context 'with proxies set' do
              let(:pre_condition) do
                [
                  'class { "cpan":
                     ftp_proxy  => "http://your_ftp_proxy.com",
                     http_proxy => "http://your_http_proxy.com",
                   }
                  ',
                ]
              end

              it { is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_content(%r{^  'ftp_proxy' => q\[http://your_ftp_proxy\.com\],$}) }
              it { is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_content(%r{^  'http_proxy' => q\[http://your_http_proxy\.com\],$}) }
            end
            context 'with custom param set' do
              describe 'string' do
                let(:pre_condition) do
                  [
                    'class { "cpan":
                      config_hash  => { "foo" => "bar" }
                    }',
                  ]
                end

                it { is_expected.to contain_file('/usr/share/perl5/CPAN/Config.pm').with_content(%r{^  'foo' => q\[bar],$}) }
              end
              describe 'array' do
                let(:pre_condition) do
                  [
                    'class {"cpan":
                      config_hash  => { "foo" => ["baz","bar"] }
                    }',
                  ]
                end

                it do
                  verify_contents(catalogue, '/usr/share/perl5/CPAN/Config.pm', [
                                    "  'foo' => [",
                                    '    q[baz],',
                                    '    q[bar]',
                                  ])
                end
              end
            end
            context 'with urllist set' do
              describe 'single url' do
                let(:pre_condition) do
                  'class { "cpan":
                    urllist => ["http://httpupdate3.cpanel.net/CPAN/"],
                  }'
                end

                it do
                  verify_contents(catalogue, '/usr/share/perl5/CPAN/Config.pm', [
                                    "  'urllist' => [",
                                    '    q[http://httpupdate3.cpanel.net/CPAN/]',
                                    '  ],',
                                  ])
                end
              end
              describe 'two urls' do
                let(:pre_condition) do
                  'class { "::cpan":
                    urllist => [
                      "http://httpupdate3.cpanel.net/CPAN/",
                      "ftp://cpan.cse.msu.edu/"
                    ],
                  }'
                end

                it do
                  verify_contents(catalogue, '/usr/share/perl5/CPAN/Config.pm', [
                                    "  'urllist' => [",
                                    '    q[http://httpupdate3.cpanel.net/CPAN/],',
                                    '    q[ftp://cpan.cse.msu.edu/]',
                                    '  ],',
                                  ])
                end
              end
            end
          end
        end
      end
    end
  end
end
