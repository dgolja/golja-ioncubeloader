# private class
# this class can be used if you don't manage the http service
# with another puppet module and you would like to restart
# the service after installing the ioncubeloader
class ioncubeloader::service inherits ioncubeloader::params {

  service { 'httpd':
    ensure => running,
    name   => $ioncubeloader::params::service_name,
    enable => true,
  }
}