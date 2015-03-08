name              'tungsten'
maintainer        'VMWare'
license           'Apache'
description       'Installs and manages Tungsten replicator, manager and connector'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.2.0'

depends 'selinux', '~> 0.8.0'
depends 'apt'
depends 'mysql', '~> 4.1.2'
depends 'java'