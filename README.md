Tor Module
==========

master branch [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-tor.png?branch=master)](http://travis-ci.org/razorsedge/puppet-tor)
develop branch [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-tor.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-tor)

Introduction
------------

This module installs the [Tor](https://www.torproject.org/) onion router.

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

* None

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

