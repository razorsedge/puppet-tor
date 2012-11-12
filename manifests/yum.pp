# == Class: tor::yum
#
# Full description of class tor::yum here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Example
#
#  class { tor::yum:
#    yum_server => 'http://localhost/'
#  }
#
# === Authors
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class tor::yum (
  $yum_server   = $tor::params::yum_server,
  $yum_path     = $tor::params::yum_path,
  $yum_priority = $tor::params::yum_priority,
  $yum_protect  = $tor::params::yum_protect
) inherits tor::params {
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
        gpgkey   => $majdistrelease ? {
          '5'     => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.EL5.asc",
          default => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.asc",
        },
        baseurl  => "${yum_server}${yum_path}/${tor::params::baseurl_string}/${majdistrelease}/\$basearch/",
        priority => $yum_priority,
        protect  => $yum_protect,
      }
      yumrepo { 'tor-testing':
        descr    => 'Tor testing repo',
        enabled  => 0,
        gpgcheck => 1,
        gpgkey   => $majdistrelease ? {
          '5'     => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.EL5.asc",
          default => "${yum_server}${yum_path}/RPM-GPG-KEY-torproject.org.asc",
        },
        baseurl  => "${yum_server}${yum_path}/tor-testing/${tor::params::baseurl_string}/${majdistrelease}/\$basearch/",
        priority => $yum_priority,
        protect  => $yum_protect,
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
    }
    default: { }
  }

}
