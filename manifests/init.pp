# == Class: tor
#
# This class handles installing the Tor onion router.
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
#  class { tor: }
#
# === Authors
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class tor (
  $socksport           = $tor::params::socksport,
  $sockspolicy         = $tor::params::sockspolicy,
  $orport              = $tor::params::orport,
  $address             = $tor::params::address,
  $outboundbindaddress = $tor::params::outboundbindaddress,
  $nickname            = $tor::params::nickname,
  $myfamily            = $tor::params::myfamily,
  $bandwidthrate       = $tor::params::bandwidthrate,
  $bandwidthburst      = $tor::params::bandwidthburst,
  $numcpus             = $tor::params::numcpus,
  $contactinfo         = $tor::params::contactinfo,
  $dirport             = $tor::params::dirport,
  $dirportfrontpage    = $tor::params::dirportfrontpage,
  $exitpolicy          = $tor::params::exitpolicy,

  $ensure             = $tor::params::ensure,
  $autoupgrade        = $tor::params::safe_autoupgrade,
  $package_name       = $tor::params::package_name,
  $file_name          = $tor::params::file_name,
  $service_ensure     = $tor::params::service_ensure,
  $service_name       = $tor::params::service_name,
  $service_enable     = $tor::params::safe_service_enable,
  $service_hasrestart = $tor::params::safe_service_hasrestart,
  $service_hasstatus  = $tor::params::service_hasstatus
) inherits tor::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
      $file_ensure = 'present'
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

#  include tor::yum

  package { $package_name :
    ensure  => $package_ensure,
  }

  file { $file_name :
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => '_tor',
    content => template('tor/torrc.erb'),
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  service { $service_name :
    ensure     => $service_ensure_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
    require    => Package[$package_name],
  }

}
