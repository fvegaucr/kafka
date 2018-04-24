# == Class kafka_bi::install
#
class kafka_bi::install {

  require '::kafka_bi::params'
  include '::turn::packages'

# Installs the Package
  package { 'kafka_bi':
    ensure  => "${kafka_bi::params::kafka_bi_package_version}-${kafka_bi::params::kafka_bi_package_iteration}",
    name            => $::kafka_bi::params::kafka_bi_package,
    require         => Package['turn-jdk-1.8.0_60']
  } ->


# Create a the symlink. Uses the folder name that the package install
  file { '/opt/kafka_bi':
    ensure => 'link',
    target => "/opt/${kafka_bi::params::kafka_bi_package}-${kafka_bi::params::kafka_bi_package_version}.${kafka_bi::params::kafka_bi_package_iteration}"
  } ->

# We primarily (or only?) create this directory because some Kafka scripts have hard-coded references to it. (eg: /opt/kafka_bi/logs)
  file { $kafka_bi::params::kafka_bi_embedded_log_dir:
    ensure  => directory,
    owner   => $kafka_bi::params::user,
    group   => $kafka_bi::params::group,
    mode    => '0755',
    require => Package['kafka_bi'],
  } ->

# /var/log/kafka/ logs files
  file { $kafka_bi::params::system_log_dir:
    ensure => directory,
    owner  => $kafka_bi::params::user,
    group  => $kafka_bi::params::group,
    mode   => '0755',
  } ->

  file { "${kafka_bi::params::system_log_dir}/broker":
    ensure => directory,
    owner  => $kafka_bi::params::user,
    group  => $kafka_bi::params::group,
    mode   => '0755',
  }

  if $kafka_bi::params::limits_manage == true {
    if ! defined(Limits::Fragment['kafka/soft/nofile']) {
      limits::fragment {
        "${kafka_bi::params::user}/soft/nofile":  value => $kafka_bi::params::limits_nofile;
        "${kafka_bi::params::user}/hard/nofile":  value => $kafka_bi::params::limits_nofile;
        "${kafka_bi::params::user}/soft/nproc":   value => '32768';
        "${kafka_bi::params::user}/hard/nproc":   value => '32768';
        "${kafka_bi::params::user}/soft/memlock": value => 'unlimited';
        "${kafka_bi::params::user}/hard/memlock": value => 'unlimited';
      }
    }
  }

  # These 'log' directories are used to store the actual data being sent to Kafka.  Do not confuse them with logging
  # directories such as /var/log/*. --- '/server/turn/kafka_datalog'
  if $kafka_bi::params::tmpfs_manage == false {
    kafka_bi::install::create_log_dirs { $kafka_bi::params::log_dirs: }
  }
  else {
    # We must first create the directory that we intend to mount tmpfs on.
    file { $kafka_bi::params::tmpfs_path:
      ensure => directory,
      owner  => $kafka_bi::params::user,
      group  => $kafka_bi::params::group,
      mode   => '0750',
    }->
    mount { $kafka_bi::params::tmpfs_path:
      ensure  => mounted,
      device  => 'none',
      fstype  => 'tmpfs',
      atboot  => true,
      options => "size=${kafka_bi::params::tmpfs_size}",
    }->
    kafka_bi::install::create_log_dirs { $kafka_bi::params::log_dirs: }
  }
}
