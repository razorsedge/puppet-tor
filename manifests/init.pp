# == Class: tor
#
# This class handles installing the Tor onion router.
# https://www.torproject.org/
# Default configuration is to be a tor client.
#
# === Parameters:
#
# [*socksport*]
#   Open this port to listen for connections from SOCKS-speaking applications.
#   Default: 127.0.0.1:9050
#
# [*sockspolicy*]
#   Set an entrance policy for this server, to limit who can connect to the
#   SocksPort.
#   Default: accept *:*
#
# [*orport*]
#   Advertise this port to listen for connections from Tor clients and servers.
#   This option is required to be a Tor server.
#   Default: 0
#
# [*address*]
#   The IP address or fully qualified domain name of this server. You can leave
#   this unset, and Tor will guess your IP address. This IP address is the one
#   used to tell clients and other servers where to find your Tor server; it
#   doesn't affect the IP that your Tor client binds to.
#   Default: none
#
# [*outboundbindaddress*]
#   Make all outbound connections originate from the IP address specified. This
#   is only useful when you have multiple network interfaces, and you want all
#   of Tor's outgoing connections to use a single one.
#   Default: none
#
# [*nickname*]
#   Set the server's nickname to 'name'. Nicknames must be between 1 and 19
#   characters inclusive, and must contain only the characters [a-zA-Z0-9].
#   Default: none
#
# [*myfamily*]
#   Declare that this Tor server is controlled or administered by a group or
#   organization identical or similar to that of the other servers, defined by
#   their identity fingerprints or nicknames.
#   Default: none
#
# [*bandwidthrate*]
#   A token bucket limits the average incoming bandwidth usage on this node to
#   the specified number of bytes per second, and the average outgoing
#   bandwidth usage to that same value.
#   Default: 5 MB
#
# [*bandwidthburst*]
#   Limit the maximum token bucket size (also known as the burst) to the given
#   number of bytes in each direction.
#   Default: 10 MB
#
# [*numcpus*]
#   How many processes to use at once for decrypting onionskins and other
#   parallelizable operations.
#   Default: 0 (autodetect)
#
# [*contactinfo*]
#   Administrative contact information for server.
#   Default: none
#
# [*controlport*]
#   The port on which Tor will listen for local connections from Tor
#   controller applications.
#   If you enable the controlport, be sure to set hashedcontrolpassword or
#   cookieauthentication as well.
#   Default: none
#
# [*hashedcontrolpassword*]
#   Set hashed password to access the controlport.
#   Default: none
#
# [*cookieauthentication*]
#   Enable cookie authentication to access the controlport.
#   Can be set to 1 to be enabled.
#   Default: none
#
# [*dirportfrontpage*]
#   When this option is set, it takes an HTML file and publishes it as "/" on
#   the DirPort. Now relay operators can provide a disclaimer without needing
#   to set up a separate webserver.
#   Default: none
#
# [*dirport*]
#   If this option is nonzero, advertise the directory service on this port.
#   Default: 0
#
# [*exitpolicy*]
#   Set an exit policy for this server.
#   Default: reject *:25,reject *:119,reject *:135-139,reject *:445,
#            reject *:563,reject *:1214,reject *:4661-4666,reject *:6346-6429,
#            reject *:6699,reject *:6881-6999,accept *:*
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
#    dirportfrontpage    => '/etc/tor/tor-exit-notice.html',
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
  $socksport             = $tor::params::socksport,
  $sockspolicy           = $tor::params::sockspolicy,
  $orport                = $tor::params::orport,
  $address               = $tor::params::address,
  $outboundbindaddress   = $tor::params::outboundbindaddress,
  $nickname              = $tor::params::nickname,
  $myfamily              = $tor::params::myfamily,
  $bandwidthrate         = $tor::params::bandwidthrate,
  $bandwidthburst        = $tor::params::bandwidthburst,
  $numcpus               = $tor::params::numcpus,
  $contactinfo           = $tor::params::contactinfo,
  $controlport           = $tor::params::controlport,
  $hashedcontrolpassword = $tor::params::hashedcontrolpassword,
  $cookieauthentication  = $tor::params::cookieauthentication,
  $dirport               = $tor::params::dirport,
  $dirportfrontpage      = $tor::params::dirportfrontpage,
  $exitpolicy            = $tor::params::exitpolicy,

  $yum_server            = $tor::params::yum_server,
  $yum_path              = $tor::params::yum_path,
  $yum_priority          = $tor::params::yum_priority,
  $yum_protect           = $tor::params::yum_protect,

  $ensure                = $tor::params::ensure,
  $autoupgrade           = $tor::params::safe_autoupgrade,
  $package_name          = $tor::params::package_name,
  $file_name             = $tor::params::file_name,
  $service_ensure        = $tor::params::service_ensure,
  $service_name          = $tor::params::service_name,
  $service_enable        = $tor::params::safe_service_enable,
  $service_hasrestart    = $tor::params::safe_service_hasrestart,
  $service_hasstatus     = $tor::params::service_hasstatus
) inherits tor::params {
  # Validate our arrays
  validate_array($socksport)
  validate_array($sockspolicy)
  validate_array($orport)
  validate_array($dirport)
  validate_array($exitpolicy)

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

  if $dirportfrontpage {
    file { $dirportfrontpage :
      ensure  => $file_ensure,
      mode    => '0644',
      owner   => 'root',
      group   => '_tor',
      content => template('tor/exit-notice.html.erb'),
      require => Package[$package_name],
    }
  }

  service { $service_name :
    ensure     => $service_ensure_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
    require    => Package[$package_name],
  }
}
