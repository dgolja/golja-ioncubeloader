#ioncubeloader

##Overview

This modules install ioncube loader from [ioncube](http://www.ioncube.com/)

Tested with Travis

[![Build Status](https://travis-ci.org/n1tr0g/golja-ioncubeloader.png)](https://travis-ci.org/n1tr0g/golja-ioncubeloader)

##Module description

This modules install and register the ioncube zend php extension on your Linux system

##Installation

    $ puppet module install golja/ioncubeloader

##Usage

Install ioncubeloader

```puppet
include '::ioncubeloader'
```

Install ioncubeloader and notify the http server (apache only)

```puppet
class { '::ioncubeloader':
  manage_http_service => true
}
```

Recommended usage, if you use a third party module to manage httpd service. The example below should work with puppetlabs-apache module.

```puppet
class { '::ioncubeloader':
  notify => Service['httpd']
}
```

##Limitation

Due to how ioncube libraries are packed it's impossible to define the version of ioncube you would like to install, so the module will always fetch
the last available version from their website.  If you would like to control that use your own archive  and adjust `ioncube_server` and `ioncube_archive`
attributes. Also it's worth to mention that the module expects that the archive is in tar.gz format and the output folder is ioncube/.

##Reference

###Classes

####Public classes
* `ioncubeloader`: install and configure ioncube loader

####Private classes
* `ioncubeloader::params`: Predefine params based on facter/environment
* `ioncubeloader::service`: Manage http service in case we don't have an external module

###Parameters

####ioncubeloader

#####`ensure`

enable or disable the module. Valid values are `present` or `absent`

#####`ioncube_server`

This setting can be used to define theURL address from where to download ioncube module. Default value `http://downloads3.ioncube.com/loader_downloads/`

#####`ioncube_archive`

Archive name of the .tar.gz with the library. Default value based on your OS architecture

#####`php_version`

This setting can be used to override php version installed. If not specified, the module will use the default for your OS distro.


#####`ts`

Define threat safety disabled or enabled. Valid values are `true` or `false`. Default value false

#####`php_conf_dir`

This setting can be used to override php conf directory. If not specified, the module will use the default for your OS distro.

#####`install_prefix`

This setting can be used to override where to install the ioncube loader libraries. Default value `/usr/local`

#####`ini_file`

This setting can be used to override ioncube ini file name. Default value `ioncube.ini`

#####`manage_http_service`

This setting can be used to manage the notification of ioncube loader settings changes to the http service.  For now it supports only apache httpd. I recommend to use a third party module for that. Look above in the example section for more info. Default value `false`

## Supported Platforms

* Debian Wheezy
* Ubuntu 12+
* RedHat 5/6
* CentOS 5/6
* Amazon AMI

## License

See LICENSE file