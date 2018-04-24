# == Class kafka_bi::mirrormaker_bi
#
class kafka_bi::mirrormaker_bi {

  require '::kafka_bi::params'

# Producer file
  file { $kafka_bi::params::producer_bi_mirror:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($kafka_bi::params::producer_bi_template ),
  } ->

  # consumer file
  file { $kafka_bi::params::consumer_bi_mirror:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($kafka_bi::params::consumer_bi_template),
  } ->

# mirromaker log4j file
  file { $kafka_bi::params::mirrormaker_bi_log4j:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($kafka_bi::params::mirrormaker_bi_log4j_template),
  }

#  require 'kafka_bi::mirrormaker_bi_deploy'
}
