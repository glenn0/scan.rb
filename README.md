scan.rb
=======

A nimble parallel port scanner, written in Ruby.

Usage
-----

ruby scan.rb <hostname> <start port> <end port>

eg. ruby scan.rb scan-me.com 1 200

Issues
------

Other than being a first version and light on features, there seems to be a limitation to the number of sockets that can be simulaneously opened. Not yet sure if this is a Ruby or system limitation. I could scan a range of up to 245 ports at once. I plan resolve by breaking up larger ranges and looping.

Credits
-------

Uses code from jstorimer.
