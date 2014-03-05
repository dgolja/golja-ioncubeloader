# private class
# this class is used if you don't manage the http service
# with another puppet modules and you would like that ioncube
# make sure to restart the service after installing the module
class ioncubeloader::service inherits ioncubeloader::params {

  service { 'httpd':
    ensure => running,
    name   => $ioncubeloader::params::service_name,
    enable => true,
  }
}