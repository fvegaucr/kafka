# == Class kafka_bi::broker_bi
#
class kafka_bi::broker_bi {

  require '::kafka_bi::params'

#server properties file
  file { $kafka_bi::params::kafka_bi_config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($kafka_bi::params::kafka_bi_broker_config_template),
  } ->

# log4j.properties
  file { $kafka_bi::params::kafka_bi_logging_config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($kafka_bi::params::kafka_bi_logging_config_template),
  }
  require '::kafka_bi::broker_bi_deploy'
  
}
