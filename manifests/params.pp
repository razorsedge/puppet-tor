# == Class: tor::params
#
# This class handles OS-specific configuration of the tor module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class tor::params {
  # Customize these values if you (for example) mirror public YUM repos to your
  # internal network.
  $yum_server   = 'http://deb.torproject.org'
  $yum_path     = '/torproject.org/rpm'
  $yum_priority = '50'
  $yum_protect  = '0'

### The following parameters should not need to be changed.

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $socksport = $::tor_socksport ? {
    undef   => [ '127.0.0.1:9050' ],
    default => $::tor_socksport,
  }

  $sockspolicy = $::tor_sockspolicy ? {
    undef   => [ 'accept *:*' ],
    default => $::tor_sockspolicy,
  }

  $orport = $::tor_orport ? {
    undef   => [ '0' ],
    default => $::tor_orport,
  }

  $bandwidthrate = $::tor_bandwidthrate ? {
    undef   => '5 MB',
    default => $::tor_bandwidthrate,
  }

  $bandwidthburst = $::tor_bandwidthburst ? {
    undef   => '10 MB',
    default => $::tor_bandwidthburst,
  }

  $numcpus = $::tor_numcpus ? {
    undef   => '0',
    default => $::tor_numcpus,
  }

  $dirport = $::tor_dirport ? {
    undef   => [ '0' ],
    default => $::tor_dirport,
  }

  $exitpolicy = $::tor_exitpolicy ? {
    undef   => [ 'reject *:25', 'reject *:119', 'reject *:135-139', 'reject *:445', 'reject *:563', 'reject *:1214', 'reject *:4661-4666', 'reject *:6346-6429', 'reject *:6699', 'reject *:6881-6999', 'accept *:*' ],
    #undef   => 'reject *:25,reject *:119,reject *:135-139,reject *:445,reject *:563,reject *:1214,reject *:4661-4666,reject *:6346-6429,reject *:6699,reject *:6881-6999,accept *:*',
    default => $::tor_exitpolicy,
  }

  $cookieauthentication = $::tor_cookieauthentication ? {
    undef   => '0',
    default => $::tor_cookieauthentication,
  }

  # If it's undef, that's fine
  $address = $::tor_address
  $outboundbindaddress = $::tor_outboundbindaddress
  $nickname = $::tor_nickname
  $myfamily = $::tor_myfamily
  $contactinfo = $::tor_contactinfo
  $controlport = $::tor_controlport
  $hashedcontrolpassword  = $::tor_hashedcontrolpassword
  $cookieauthentication   = $::tor_cookieauthentication
  $excludesinglehoprelays = $::tor_excludesinglehoprelays
  $enforcedistinctsubnets = $::tor_enforcedistinctsubnets
  $allowsinglehopcircuits = $::tor_allowsinglehopcircuits
  $exitnodes              = $::tor_exitnodes
  $strictnodes            = $::tor_strictnodes

  ######################################################################

  $ensure = $::tor_ensure ? {
    undef   => 'present',
    default => $::tor_ensure,
  }

  $package_name = $::tor_package_name ? {
    undef   => 'tor',
    default => $::tor_package_name,
  }

  $file_name = $::tor_file_name ? {
    undef   => '/etc/tor/torrc',
    default => $::tor_file_name,
  }

  $service_ensure = $::tor_service_ensure ? {
    undef   => 'running',
    default => $::tor_service_ensure,
  }

  $service_name = $::tor_service_name ? {
    undef   => 'tor',
    default => $::tor_service_name,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::tor_autoupgrade ? {
    undef   => false,
    default => $::tor_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::tor_service_enable ? {
    undef   => true,
    default => $::tor_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $service_hasrestart = $::tor_service_hasrestart ? {
    undef   => true,
    default => $::tor_service_hasrestart,
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  $service_hasstatus = $::tor_service_hasstatus ? {
    undef   => true,
    default => $::tor_service_hasstatus,
  }
  if is_string($service_hasstatus) {
    $safe_service_hasstatus = str2bool($service_hasstatus)
  } else {
    $safe_service_hasstatus = $service_hasstatus
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'Fedora': {
          $baseurl_string = 'fc'  # must be lower case
        }
        default: {
          $baseurl_string = 'el'  # must be lower case
        }
      }
    }
    'Debian': {
        $baseurl_string = 'deb'  # must be lower case
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
