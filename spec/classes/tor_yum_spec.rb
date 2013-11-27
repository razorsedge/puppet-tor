#!/usr/bin/env rspec

require 'spec_helper'

describe 'tor::yum', :type => 'class' do
  let :pre_condition do
    "class {'tor': }"
  end

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
    context 'for operatingsystem RedHat, majdistrelease 5' do
      let(:params) {{}}
      let :facts do {
        :osfamily                => 'RedHat',
        :operatingsystem         => 'RedHat',
        :operatingsystemrelease  => '5'
      }
      end
      it { should contain_yumrepo('tor').with(
        :descr    => 'Tor repo',
        :enabled  => '1',
        :gpgcheck => '1',
        :gpgkey   => 'http://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.EL5.asc',
        :baseurl  => 'http://deb.torproject.org/torproject.org/rpm/el/5/$basearch/',
        :priority => '50',
        :protect  => '0'
      )}
      it { should contain_yumrepo('tor-testing').with(
        :descr    => 'Tor testing repo',
        :enabled  => '0',
        :gpgcheck => '1',
        :gpgkey   => 'http://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.EL5.asc',
        :baseurl  => 'http://deb.torproject.org/torproject.org/rpm/tor-testing/el/5/$basearch/',
        :priority => '50',
        :protect  => '0'
      )}
    end

    context 'for operatingsystem RedHat, majdistrelease 6' do
      let(:params) {{}}
      let :facts do {
        :osfamily                => 'RedHat',
        :operatingsystem         => 'RedHat',
        :operatingsystemrelease  => '6'
      }
      end
      it { should contain_yumrepo('tor').with(
        :descr    => 'Tor repo',
        :enabled  => '1',
        :gpgcheck => '1',
        :gpgkey   => 'http://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.asc',
        :baseurl  => 'http://deb.torproject.org/torproject.org/rpm/el/6/$basearch/',
        :priority => '50',
        :protect  => '0'
      )}
      it { should contain_yumrepo('tor-testing').with(
        :descr    => 'Tor testing repo',
        :enabled  => '0',
        :gpgcheck => '1',
        :gpgkey   => 'http://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.asc',
        :baseurl  => 'http://deb.torproject.org/torproject.org/rpm/tor-testing/el/6/$basearch/',
        :priority => '50',
        :protect  => '0'
      )}
    end

    context 'for operatingsystem Fedora' do
      (['16', '17']).each do |mdr|
        describe "for majdistrelease #{mdr}" do
          let(:params) {{}}
          let :facts do {
            :osfamily                => 'RedHat',
            :operatingsystem         => 'Fedora',
            :operatingsystemrelease  => mdr
          }
          end
          it { should contain_yumrepo('tor').with(
            :descr    => 'Tor repo',
            :enabled  => '1',
            :gpgcheck => '1',
            :gpgkey   => 'http://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.asc',
            :baseurl  => "http://deb.torproject.org/torproject.org/rpm/fc/#{mdr}/$basearch/",
            :priority => '50',
            :protect  => '0'
          )}
          it { should contain_yumrepo('tor-testing').with(
            :descr    => 'Tor testing repo',
            :enabled  => '0',
            :gpgcheck => '1',
            :gpgkey   => 'http://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.asc',
            :baseurl  => "http://deb.torproject.org/torproject.org/rpm/tor-testing/fc/#{mdr}/$basearch/",
            :priority => '50',
            :protect  => '0'
          )}
        end
      end
    end
  end

end
