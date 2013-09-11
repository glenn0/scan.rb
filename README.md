scan.rb
=======

A nimble parallel port scanner, written in Ruby.

Development Status
------------------

Scan.rb is in active but early development. Master branch should be stable for use cases specified below. Other branches are more than likely unstable.

Usage
-----

scan.rb takes a hostname and port set as arguments and returns a list of ports accepting connections in terminal.

The format is:

ruby scan.rb \<hostname\> \<port set\>

### Valid Port Sets
#### Single Port

A single valid port number.

ruby scan.rb \<hostname\> \<1-65535\>

eg. ```ruby scan.rb scanme.com 80``` (scans port 80)

#### Port Range

Two valid ports, joins with a hyphen. NOTE: First port must be lower than second.

ruby scan.rb \<hostname\> \<1-65535\>-\<1-65535\>

eg. ```ruby scan.rb scanme.com 1-100``` (scans ports 1 to 100 inclusive)

#### Port List

A list of comma-separated, valid port numbers. Order doesn't matter. NB: Don't use spaces!

ruby scan.rb \<hostname\> \<1-65535\>(,\<1-65535\>)*n

eg. ```ruby scan.rb scanme.com 80,22,443``` (scans ports 80, 22 then 443)


Issues
------

Other than being a first version and light on features, there seems to be a limitation to the number of sockets that can be simulaneously opened. Not yet sure if this is a Ruby or system limitation. I could scan a range of up to 245 ports at once. I plan to resolve by breaking up larger ranges and looping.

Under active development. More to come shortly.

Credits
-------

Uses code from [jstorimer](https://github.com/jstorimer).
