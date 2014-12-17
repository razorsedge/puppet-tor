Puppet Tor Module
=================

master branch [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-tor.png?branch=master)](http://travis-ci.org/razorsedge/puppet-tor)
develop branch [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-tor.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-tor)

Introduction
------------

This module installs the [Tor](https://www.torproject.org/) onion router from the Tor Project's software repository.  Tor protects you by bouncing your communications around a distributed network of relays run by volunteers all around the world: it prevents somebody watching your Internet connection from learning what sites you visit, and it prevents the sites you visit from learning your physical location. Tor works with many of your existing applications, including web browsers, instant messaging clients, remote login, and other applications based on the TCP protocol.

Actions:

* Installs the Tor Project's YUM repositories.
* Installs Tor.

OS Support:

* RedHat family - tested on CentOS 5.8+ and CentOS 6.3+
* Debian family - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

    # Top Scope variable (i.e. via Dashboard):
    tor_socksport = '127.0.0.1:9050'
    include 'tor'

    # Declare yum repository if needed
    include 'tor::yum'

    # Parameterized Class:
    class { 'tor':
      socksport => '127.0.0.1:9050',
    }

Notes
-----

* None

Issues
------

* None

TODO
----

* Allow users to choose Fedora or EPEL YUM repos?
* Allow for removal of yumrepo.

Contributing
------------

Please see DEVELOP.md for contribution information.

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

[razorsedge/puppet-tor on GitHub](https://github.com/razorsedge/puppet-tor)

[razorsedge/tor on Puppet Forge](http://forge.puppetlabs.com/razorsedge/tor)

