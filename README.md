#puppet-sysctl#

* This modules allows dynamic configuration of sysctl values.

##Usage##

  Basic:
```puppet
  sysctl::value { "vm.overcommit_memory": value => '1'; }
```
  When setting a key that contains multiple values, use a tab to separate the
  values:
```puppet
  node "mynode" inherits ... {
    sysctl::value { 'net.ipv4.tcp_rmem':
        value => "4096\t131072\t131072",
    }
  }
```
  To avoid duplication the sysctl::value calls multiple settings can be 
  managed like this:
```puppet
  $my_sysctl_settings = {
    "net.ipv4.ip_forward"          => { value => 1 },
    "net.ipv6.conf.all.forwarding" => { value => 1 },
  }

  # Specify defaults for all the sysctl::value to be created
  $my_sysctl_defaults = {
    require => Package['aa']
  }

  create_resources(sysctl::value,$my_sysctl_settings,$my_sysctl_defaults)
```

##License##

 Copyright (C) 2011 Immerda Project Group
 Author mh <mh@immerda.ch>
 Modified by Nicolas Zin <nicolas.zin@savoirfairelinux.com>
 Modified by Jeff Vier <jeff@jeffvier.com>
 Licence: GPL v2
