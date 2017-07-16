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
  $tor_socksport = getvar('::tor_socksport')
  if $tor_socksport {
    $socksport = $::tor_socksport
  } else {
    $socksport = [ '127.0.0.1:9050', ]
  }

  $tor_sockspolicy = getvar('::tor_sockspolicy')
  if $tor_sockspolicy {
    $sockspolicy = $::tor_sockspolicy
  } else {
    $sockspolicy = [ 'accept *:*', ]
  }

  $tor_orport = getvar('::tor_orport')
  if $tor_orport {
    $orport = $::tor_orport
  } else {
    $orport = [ '0', ]
  }

  $tor_bandwidthrate = getvar('::tor_bandwidthrate')
  if $tor_bandwidthrate {
    $bandwidthrate = $::tor_bandwidthrate
  } else {
    $bandwidthrate = '5 MB'
  }

  $tor_bandwidthburst = getvar('::tor_bandwidthburst')
  if $tor_bandwidthburst {
    $bandwidthburst = $::tor_bandwidthburst
  } else {
    $bandwidthburst = '10 MB'
  }

  $tor_numcpus = getvar('::tor_numcpus')
  if $tor_numcpus {
    $numcpus = $::tor_numcpus
  } else {
    $numcpus = '0'
  }

  $tor_dirport = getvar('::tor_dirport')
  if $tor_dirport {
    $dirport = $::tor_dirport
  } else {
    $dirport = [ '0', ]
  }

  $tor_exitpolicy = getvar('::tor_exitpolicy')
  if $tor_exitpolicy {
    $exitpolicy = $::tor_exitpolicy
  } else {
    $exitpolicy = [ 'reject *:25', 'reject *:119', 'reject *:135-139', 'reject *:445', 'reject *:563', 'reject *:1214', 'reject *:4661-4666', 'reject *:6346-6429', 'reject *:6699', 'reject *:6881-6999', 'accept *:*' ]
  }

  # If it's undef, that's fine
  $address = getvar('::tor_address')
  $outboundbindaddress = getvar('::tor_outboundbindaddress')
  $nickname = getvar('::tor_nickname')
  $myfamily = getvar('::tor_myfamily')
  $contactinfo = getvar('::tor_contactinfo')
  $dirportfrontpage = getvar('::tor_dirportfrontpage')

  ######################################################################

  $tor_ensure = getvar('::tor_ensure')
  if $tor_ensure {
    $ensure = $::tor_ensure
  } else {
    $ensure = 'present'
  }

  $tor_package_name = getvar('::tor_package_name')
  if $tor_package_name {
    $package_name = $::tor_package_name
  } else {
    $package_name = 'tor'
  }

  $tor_file_name = getvar('::tor_file_name')
  if $tor_file_name {
    $file_name = $::tor_file_name
  } else {
    $file_name = '/etc/tor/torrc'
  }

  $tor_service_ensure = getvar('::tor_service_ensure')
  if $tor_service_ensure {
    $service_ensure = $::tor_service_ensure
  } else {
    $service_ensure = 'running'
  }

  $tor_service_name = getvar('::tor_service_name')
  if $tor_service_name {
    $service_name = $::tor_service_name
  } else {
    $service_name = 'tor'
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $tor_autoupgrade = getvar('::tor_autoupgrade')
  if $tor_autoupgrade {
    $autoupgrade = $::tor_autoupgrade
  } else {
    $autoupgrade = false
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $tor_service_enable = getvar('::tor_service_enable')
  if $tor_service_enable {
    $service_enable = $::tor_service_enable
  } else {
    $service_enable = true
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $tor_service_hasrestart = getvar('::tor_service_hasrestart')
  if $tor_service_hasrestart {
    $service_hasrestart = $::tor_service_hasrestart
  } else {
    $service_hasrestart = true
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  $tor_service_hasstatus = getvar('::tor_service_hasstatus')
  if $tor_service_hasstatus {
    $service_hasstatus = $::tor_service_hasstatus
  } else {
    $service_hasstatus = true
  }
  if is_string($service_hasstatus) {
    $safe_service_hasstatus = str2bool($service_hasstatus)
  } else {
    $safe_service_hasstatus = $service_hasstatus
  }

  if $::operatingsystemmajrelease { # facter 1.7+
    $majdistrelease = $::operatingsystemmajrelease
  } elsif $::lsbmajdistrelease {    # requires LSB to already be installed
    $majdistrelease = $::lsbmajdistrelease
  } elsif $::os_maj_version {       # requires stahnma/epel
    $majdistrelease = $::os_maj_version
  } else {
    $majdistrelease = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1')
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'Fedora': {
          case $majdistrelease {
            '19', '20', '21': {
              $baseurl_string = 'fc'  # must be lower case
            }
            default: {
              fail("Your operating system release ${::operatingsystem} ${majdistrelease} is not supported.")
            }
          }
        }
        default: {
          case $majdistrelease {
            '6', '7': {
              $baseurl_string = 'el'  # must be lower case
            }
            default: {
              fail("Your operating system release ${::operatingsystem} ${majdistrelease} is not supported.")
            }
          }
        }
      }
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
