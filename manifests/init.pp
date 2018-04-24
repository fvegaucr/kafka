# == Class: kafka_bi
#
# Deploys an Apache Kafka Confluent.
#
# Note: When using a custom namespace/chroot in the ZooKeeper connection string you must manually create the namespace
#       in ZK first (e.g. in 'localhost:2181/kafka' the namespace is '/kafka_telcobidlog').

class kafka_bi {
  require '::kafka_bi::params'
  include '::kafka_bi::users'
  include '::kafka_bi::install'
  include '::kafka_bi::topics'
  include '::kafka_bi::broker_bi_install'
  include '::kafka_bi::mirrormaker_bi_install'

  # Validation

  validate_hash($::kafka_bi::params::brokerid_map)
  if !has_key($::kafka_bi::params::brokerid_map, $::fqdn) { fail('Kafka class assigned to host but host is not in brokerid_map hash') }
  if !has_key($::kafka_bi::params::brokerid_map[$::fqdn], 'brokerid') { fail('Kafka host in brokerid map, but does not have brokerid assigned.') }


  ::monitoring::group { 'kafka_bi-puppet': }
  ::cmdb::puppet_services { 'kafka_bi': }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'kafka_bi::begin': }
  anchor { 'kafka_bi::end': }

  Anchor['kafka_bi::begin']
  -> Class['::kafka_bi::users']
  -> Class['::kafka_bi::install']
  -> Class['::kafka_bi::broker_bi_install']
  -> Class['::kafka_bi::mirrormaker_bi_install']
  -> Anchor['kafka_bi::end']
}
