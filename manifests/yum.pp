# == Class: tor::yum
#
# This class will install the YUM repository for Tor on supported operating
# systems.
#
# === Parameters:
#
# [*yum_server*]
#   The URL for the YUM server host.
#   Default: http://deb.torproject.org
#
# [*yum_path*]
#   The URL path.
#   Default: /torproject.org/rpm
#
# [*yum_priority*]
#   The priority that the Tor YUM repos will have.
#   Default: 50
#
# [*yum_protect*]
#   Whether to protect this YUM repo.
#   Default: 0
#
# === Actions:
#
# Configures a YUM repository on supported operating systems.
#
# === Sample Usage:
#
#  class { tor::yum:
#    yum_server => 'http://localhost/'
#  }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class tor::yum (
  $yum_server   = $tor::params::yum_server,
  $yum_path     = $tor::params::yum_path,
  $yum_priority = $tor::params::yum_priority,
  $yum_protect  = $tor::params::yum_protect
) inherits tor::params {

  Class['tor::yum'] -> Class['tor']

  # We use $::operatingsystem and not $::osfamily because certain things
  # (like Fedora) need to be excluded.
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Scientific', 'SLC', 'Ascendos', 'PSBM', 'OVS', 'OEL',
    'OracleLinux': {
      $majdistrelease = $::lsbmajdistrelease ? {
        ''      => regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1'),
        default => $::lsbmajdistrelease,
      }
      yumrepo { 'tor':
        descr    => 'Tor repo',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.asc",
        baseurl  => "${yum_server}${yum_path}/${tor::params::baseurl_string}/${majdistrelease}/\$basearch/",
        priority => $yum_priority,
        protect  => $yum_protect,
      }
      yumrepo { 'tor-testing':
        descr    => 'Tor testing repo',
        enabled  => 0,
        gpgcheck => 1,
        gpgkey   => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.asc",
        baseurl  => "${yum_server}${yum_path}/tor-testing/${tor::params::baseurl_string}/${majdistrelease}/\$basearch/",
        priority => $yum_priority,
        protect  => $yum_protect,
      }

      file { '/etc/yum.repos.d/tor.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
      file { '/etc/yum.repos.d/tor-testing.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    }
    'Fedora': {
      yumrepo { 'tor':
        descr    => 'Tor repo',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.asc",
        baseurl  => "${yum_server}${yum_path}/${tor::params::baseurl_string}/${::operatingsystemrelease}/\$basearch/",
        priority => $yum_priority,
        protect  => $yum_protect,
      }
      yumrepo { 'tor-testing':
        descr    => 'Tor testing repo',
        enabled  => 0,
        gpgcheck => 1,
        gpgkey   => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.asc",
        baseurl  => "${yum_server}${yum_path}/tor-testing/${tor::params::baseurl_string}/${::operatingsystemrelease}/\$basearch/",
        priority => $yum_priority,
        protect  => $yum_protect,
      }

      file { '/etc/yum.repos.d/tor.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
      file { '/etc/yum.repos.d/tor-testing.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    }
    default: { }
  }
}
