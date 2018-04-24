# This wrapper class is designed to co-host mirrormaker instances with Kafka brokers
# $dc parameter is normally the Aggregation datacenter kafka cluster, never needs an override (hopefully)
# $cluster parameter defines source and destination cluster name
# Since we co-host with Kafka brokers $kafka_cluster_id is known, so we just use it
# as default

class kafka_bi::topics (
  $dc = $kafka_bi::params::kafka_bi_dest_dc,
  $cluster = $::kafka_cluster_id
)
  {
    kafka_bi::mirrormaker_bi_deploy { "hkg1-to-${dc}":
      source_dc => 'hkg1',
      dest_dc   => $dc,
      cluster   => $cluster,
      topiclist => kafka_bi::params::topiclist,
      jmx_port  => 10001,
      num_procs => kafka_bi::params::mirrormaker_bi_num_procs
    }
    kafka_bi::mirrormaker_bi_deploy { "atl1-to-${dc}":
      source_dc => 'atl1',
      dest_dc   => $dc,
      cluster   => $cluster,
      topiclist => kafka_bi::params::topiclist,
      jmx_port  => 10011,
      num_procs => kafka_bi::params::mirrormaker_bi_num_procs
    }
    kafka_bi::mirrormaker_bi_deploy { "ams1-to-${dc}":
      source_dc => 'ams1',
      dest_dc   => $dc,
      cluster   => $cluster,
      topiclist => kafka_bi::params::topiclist,
      jmx_port  => 10001,
      num_procs => kafka_bi::params::mirrormaker_bi_num_procs
    }
    kafka_bi::mirrormaker_bi_deploy { "sjc2-to-${dc}":
      source_dc => 'sjc2',
      dest_dc   => $dc,
      cluster   => $cluster,
      topiclist => kafka_bi::params::topiclist,
      jmx_port  => 10011,
      num_procs => kafka_bi::params::mirrormaker_bi_num_procs
    }
  }

