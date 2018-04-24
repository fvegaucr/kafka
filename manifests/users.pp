# == Class kafka_bi::users
#

class kafka_bi::users {
  require '::kafka_bi::params'

  if $::kafka_bi::params::user_manage == true {
    if ! defined(Group['kafka_bi']) {

      group { $::kafka_bi::params::group:
        ensure => $::kafka_bi::params::group_ensure,
        gid    => $::kafka_bi::params::gid,
      }

      user { $::kafka_bi::params::user:
        ensure     => $::kafka_bi::params::user_ensure,
        home       => $::kafka_bi::params::user_home,
        shell      => $::kafka_bi::params::shell,
        uid        => $::kafka_bi::params::uid,
        comment    => $::kafka_bi::params::user_description,
        gid        => $::kafka_bi::params::group,
        managehome => $::kafka_bi::params::user_managehome,
        require    => Group[$::kafka_bi::params::group],
      }
    }
  }
}
