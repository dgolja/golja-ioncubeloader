# == Class: ioncubeloader
#
# Install ioncube loader module for php
#
# === Parameters
#
# Please for full parameters documentation check README.md
#
# Dejan Golja <dejan@golja.org>
#
# === Copyright
#
# Copyright 2014 Dejan Golja, unless otherwise noted.
#
class ioncubeloader(
  $ensure              = 'present',
  $ioncube_server      = $ioncubeloader::params::ioncube_server,
  $ioncube_archive     = $ioncubeloader::params::archive_file,
  $php_version         = $ioncubeloader::params::php_version,
  $ts                  = false,
  $php_conf_dir        = $ioncubeloader::params::php_conf_dir,
  $install_prefix      = '/usr/local',
  $ini_file            = 'ioncube.ini',
  $manage_http_service = false,
) inherits ioncubeloader::params {

  Exec {
    path => ['/bin', '/usr/bin']
  }

  if !($ensure in ['present', 'absent']) {
    fail('ensure must be either present or absent')
  }

  if $ts {
    $ioncube_loader = "${ioncubeloader::params::ioncube_loader_base}_${php_version}_ts.so"
  } else {
    $ioncube_loader = "${ioncubeloader::params::ioncube_loader_base}_${php_version}.so"
  }

  if $manage_http_service {
    class { 'ioncubeloader::service':
      subscribe => File["${php_conf_dir}/${ini_file}"]
    }
  }

  file { "${php_conf_dir}/${ini_file}":
    ensure  => $ensure,
    content => ";Managed by puppet\nzend_extension=${install_prefix}/ioncube/${ioncube_loader}\n"
  }

  if $ensure == 'present' {
    exec { 'retrieve_ioncubeloader':
      cwd     => '/tmp',
      command => "wget ${$ioncube_server}${ioncube_archive} && tar xzf ${ioncube_archive} && mv ioncube/ ${install_prefix} && touch ${install_prefix}/ioncube/.installed",
      creates => "${install_prefix}/ioncube/.installed"
    }
  }
  else {
    file { "${install_prefix}/ioncube":
      ensure  => $ensure,
      backup  => false,
      recurse => true,
      force   => true,
    }
    file { "/tmp/${ioncube_archive}":
      ensure => $ensure,
      backup => false,
    }
  }
}
