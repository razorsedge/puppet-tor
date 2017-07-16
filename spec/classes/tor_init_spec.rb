#!/usr/bin/env rspec

require 'spec_helper'

describe 'tor', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Unsupported platform: foo/)
      }
    end
  end

  context 'on a supported operatingsystem, default parameters' do
    let(:params) {{}}
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6',
      :operatingsystemmajrelease => '6'
    }
    end
    it { should contain_class('tor::yum') }
    it { should contain_package('tor').with_ensure('present') }
    it { should contain_file('/etc/tor/torrc').with(
      :ensure => 'present',
      :mode   => '0644',
      :owner  => 'root',
      :group  => '_tor'
    )}
    it { should_not contain_file('/etc/tor/tor-exit-notice.html') }
    it { should contain_service('tor').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true,
      :hasstatus  => true
    )}

#    context 'for operatingsystem RedHat' do
#      (['5', '6']).each do |mdr|
#        describe "for majdistrelease #{mdr}" do
#          let(:params) {{}}
#          let :facts do {
#            :osfamily               => 'RedHat',
#            :operatingsystem        => 'RedHat',
#            :operatingsystemrelease => mdr,
#            :operatingsystemmajrelease => mdr
#          }
#          end
#          it { should contain_package('tor').with_ensure('present') }
#          it { should contain_service('tor').with(
#            :ensure     => 'running',
#            :enable     => true,
#            :hasrestart => true,
#            :hasstatus  => true
#          )}
#        end
#      end
#    end
#
#    context 'for operatingsystem Fedora' do
#      (['16', '17']).each do |mdr|
#        describe "for majdistrelease #{mdr}" do
#          let(:params) {{}}
#          let :facts do {
#            :osfamily               => 'RedHat',
#            :operatingsystem        => 'Fedora',
#            :operatingsystemrelease => mdr,
#            :operatingsystemmajrelease => mdr
#          }
#          end
#          it { should contain_package('tor').with_ensure('present') }
#          it { should contain_service('tor').with(
#            :ensure     => 'running',
#            :enable     => true,
#            :hasrestart => true,
#            :hasstatus  => true
#          )}
#        end
#      end
#    end
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6',
      :operatingsystemmajrelease => '6'
    }
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent'
      }
      end
      it { should contain_class('tor::yum') }
      it { should contain_package('tor').with_ensure('absent') }
      it { should contain_file('/etc/tor/torrc').with_ensure('absent') }
      it { should_not contain_file('/etc/tor/tor-exit-notice.html') }
      it { should contain_service('tor').with(
        :ensure => 'stopped',
        :enable => false
      )}
    end

    describe 'autoupgrade => true' do
      let :params do {
        :autoupgrade => true
      }
      end
      it { should contain_class('tor::yum') }
      it { should contain_package('tor').with_ensure('latest') }
      it { should contain_file('/etc/tor/torrc').with_ensure('present') }
      it { should_not contain_file('/etc/tor/tor-exit-notice.html') }
      it { should contain_service('tor').with(
        :ensure => 'running',
        :enable => true
      )}
    end

    describe 'package_name => not-tor' do
      let :params do {
        :package_name => 'not-tor'
      }
      end
      it { should contain_class('tor::yum') }
      it { should contain_package('not-tor').with_ensure('present') }
      it { should contain_file('/etc/tor/torrc').with_ensure('present') }
      it { should_not contain_file('/etc/tor/tor-exit-notice.html') }
      it { should contain_service('tor').with(
        :ensure => 'running',
        :enable => true
      )}
    end

    describe 'dirportfrontpage => /etc/tor/tor-exit-notice.html' do
      let :params do {
        :dirportfrontpage => '/etc/tor/tor-exit-notice.html',
        :address          => '1.2.3.4',
        :contactinfo      => 'root@localhost'
      }
      end
      it { should contain_class('tor::yum') }
      it { should contain_package('tor').with_ensure('present') }
      it { should contain_file('/etc/tor/torrc').with_ensure('present') }
      it { should contain_file('/etc/tor/tor-exit-notice.html').with(
        :ensure => 'present',
        :mode   => '0644',
        :owner  => 'root',
        :group  => '_tor'
      )}
      it 'should contain File[/etc/tor/tor-exit-notice.html] with correct contents' do
        verify_contents(catalogue, '/etc/tor/tor-exit-notice.html', [
          '1.2.3.4 should not constitute probable cause to seize the',
          'email the <a href="mailto:root@localhost">maintainer</a>. If',
        ])
      end
      it { should contain_service('tor').with(
        :ensure => 'running',
        :enable => true
      )}
    end
  end

end
