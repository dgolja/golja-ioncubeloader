#PRIVATE class to retrieve default values
class ioncubeloader::params {
  $ioncube_server = 'http://downloads3.ioncube.com/loader_downloads/'

  if $::hardwaremodel == 'x86_64' {
    $package_suffix = '-64'
  } else {
    $package_suffix = ''
  }

  # http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz
  $archive_file = "ioncube_loaders_lin_x86${package_suffix}.tar.gz"

  if $::osfamily == 'RedHat' or $::operatingsystem == 'amazon' {
      $service_name     = 'httpd'
      $php_version      = '5.3'
      $php_conf_dir     = '/etc/php.d'
      $service_provider = undef
  } elsif $::osfamily == 'Debian' {
      $service_name = 'apache2'
      case $::operatingsystemmajrelease {
        8: { $php_version  = '5.6'}
        7: { $php_version  = '5.4'}
        6: { $php_version  = '5.3'}
        default: { $php_version  = '5.4' }
      }
      $php_conf_dir = '/etc/php5/conf.d'
      if $::operatingsystem == 'Ubuntu' {
        $service_provider = 'upstart'
      }
      else {
        $service_provider = undef
      }
  }
  else {
    fail("Unsupported osfamily ${::osfamily}")
  }

  $ioncube_loader_base = 'ioncube_loader_lin'
}
