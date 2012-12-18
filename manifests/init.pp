# == Class: tor
#
# This class handles installing the Tor onion router.
# https://www.torproject.org/
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
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*package_name*]
#   Name of the package.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*file_name*]
#   Name of the client config file.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_name*]
#   Name of the service
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_enable*]
#   Start service at boot.
#   Default: false
#
# [*service_hasrestart*]
#   Service has restart command.
#   Default: true
#
# [*service_hasstatus*]
#   Service has status command.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: true
#
# === Actions:
#
# Installs the tor package.
# Manages the torrc file.
# Starts the tor service.
#
# === Sample Usage:
#
#  # default client
#  class { 'tor': }
#
#  # relay only
#  class { 'tor':
#    socksport           => [ '0' ],
#    sockspolicy         => [ 'reject *' ],
#    orport              => [ '443 NoListen', '10.2.3.4:9090 NoAdvertise' ],
#    address             => '10.2.3.4',
#    outboundbindaddress => '10.2.3.4',
#    nickname            => 'ididnteditheconfig',
#    myfamily            => '10.2.3.5',
#    bandwidthrate       => '100 MB',
#    bandwidthburst      => '200 MB',
#    numcpus             => '2',
#    contactinfo         => 'Random Person <nobody AT example dot com>',
#    dirport             => [ '80 NoListen', '10.2.3.4:9091 NoAdvertise' ],
#    exitpolicy          => [ 'reject *:*' ],
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
  $exitpolicy          = $tor::params::exitpolicy,

  $yum_server          = $tor::params::yum_server,
  $yum_path            = $tor::params::yum_path,
  $yum_priority        = $tor::params::yum_priority,
  $yum_protect         = $tor::params::yum_protect,

  $ensure              = $tor::params::ensure,
  $autoupgrade         = $tor::params::safe_autoupgrade,
  $package_name        = $tor::params::package_name,
  $file_name           = $tor::params::file_name,
  $service_ensure      = $tor::params::service_ensure,
  $service_name        = $tor::params::service_name,
  $service_enable      = $tor::params::safe_service_enable,
  $service_hasrestart  = $tor::params::safe_service_hasrestart,
  $service_hasstatus   = $tor::params::service_hasstatus
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

  Class['tor::yum'] -> Class['tor']

  class { 'tor::yum' :
    yum_server   => $yum_server,
    yum_path     => $yum_path,
    yum_priority => $yum_priority,
    yum_protect  => $yum_protect,
  }

  package { $package_name :
    ensure => $package_ensure,
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
