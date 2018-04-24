# == Define kafka_mirrormaker::mirrormaker
#
#
define kafka_bi::mirrormaker_bi_deploy (
  $source_dc,
  $cluster,
  $dest_dc = $::domain_short,
  $topiclist = $::kafka_bi::params::topiclist,
  $num_streams = $::kafka_bi::params::mirrormaker_bi_num_streams,
  $num_procs = $::kafka_bi::params::mirrormaker_bi_num_of_procs,
  $jmx_port = 10001
) {
# ::kafka::params is required due to is use on consumer.erb line 4 to obtain the list of hosts/brokers and ports.
  require '::kafka_bi::params'
  include '::kafka_bi::users'
  include '::kafka_bi::install'

  ensure_resource( 'cmdb::puppet_services', 'kafka_bi_mirrormaker' )

  $kafka_class = 'kafka.tools.MirrorMaker'
  $service_name = "${kafka_bi::params::mirrormaker_bi_service_name}-${name}"

  $source_zk = hiera('kafka_bi::params::zookeeper_connect', ['localhost:2181'], "kafka/kafka.${cluster}")
  $zk_chroot = hiera('kafka_bi::params::zk_chroot', '/kafka_bi', "kafka/kafka.${cluster}")

  $kafka_gc_log_opts_suffix = "-Xloggc:${kafka_bi::params::mirrormaker_bi_gc_log_file}-${name}"
  
  if $kafka_bi::params::mirrormaker_gc_log_opts {
    $kafka_gc_log_opts_real = "KAFKA_GC_LOG_OPTS_PREP=\" ${kafka_bi::params::mirrormaker_bi_gc_log_opts} ${kafka_gc_log_opts_suffix}\""
  }
  else {
    $kafka_gc_log_opts_real = "KAFKA_GC_LOG_OPTS_PREP=\"${kafka_gc_log_opts_suffix}\""
  }

  if $kafka_bi::params::mirrormaker_bi_heap_opts {
    $kafka_heap_opts_real = "KAFKA_HEAP_OPTS=\"${kafka_bi::params::mirrormaker_bi_heap_opts}\""
  }
  else {
    $kafka_heap_opts_real = ''
  }

  if $kafka_bi::params::mirrormaker_bi_jmx_opts {
    $kafka_jmx_opts_real = "KAFKA_JMX_OPTS=\"${kafka_bi::params::mirrormaker_bi_jmx_opts}\""
  }
  else {
    $kafka_jmx_opts_real = ''
  }

  if $kafka_bi::params::mirrormaker_bi_jvm_performance_opts {
    $kafka_jvm_performance_opts_real = "KAFKA_JVM_PERFORMANCE_OPTS=\"${kafka_bi::params::mirrormaker_bi_jvm_performance_opts}\""
  }
  else {
    $kafka_jvm_performance_opts_real = ''
  }

  $kafka_log4j_opts_suffix = "-Dlog4j.configuration=file:${kafka_bi::params::kafka_bi_base_dir}/config/mirrormaker_bi_log4j.properties-${name}"
  
  if $kafka_bi::params::mirrormaker_bi_log4j_opts {
    $kafka_log4j_opts_real = "KAFKA_LOG4J_OPTS_PREP=\"${kafka_bi::params::mirrormaker_bi_log4j_opts} ${kafka_log4j_opts_suffix}\""
  }
  else {
    $kafka_log4j_opts_real = "KAFKA_LOG4J_OPTS_PREP=\"${kafka_log4j_opts_suffix}\""
  }

  $mirrormaker_bi_commandline="\"--num.streams ${kafka_bi::params::mirrormaker_bi_num_streams} --consumer.config ${kafka_bi::params::consumer_bi_mirror} --producer.config ${kafka_bi::params::producer_bi_mirror} --whitelist=\\\"${kafka_bi::params::topiclist}\\\"\""

  if $kafka_bi::params::mirrormaker_bi_opts {
    $kafka_opts_real = "KAFKA_OPTS=\"${kafka_bi::params::mirrormaker_bi_opts}\""
  }
  else {
    $kafka_opts_real = ''
  }

  if $kafka_bi::params::mirrormaker_bi_service_enable {
    $service_running = 'running'
  }
  else {
    $service_running = 'stopped'
  }

  $mirrormaker_bi_environment="JMX_PORT=${kafka_bi::params::mirrormaker_bi_jmx_port} ${kafka_gc_log_opts_real} ${kafka_heap_opts_real} ${kafka_jmx_opts_real} ${kafka_jvm_performance_opts_real} ${kafka_log4j_opts_real} ${kafka_opts_real}"

  Class['::kafka_bi::users'] ->
  Class['::kafka_bi::install'] ->

  file { "${::kafka_bi::params::mirrormaker_bi_service_name}.init-${name}":
    ensure  => file,
    path    => "/etc/init.d/${::kafka_bi::params::mirrormaker_bi_service_name}-${name}",
    mode    => '0755',
    #content => template('kafka_bi/mirrormaker_bi.init.erb'),
    content => template($kafka_bi::params::mirrormaker_bi_init_script_template),
  } ->

  file { "consumer_bi-${name}.properties":
    ensure  => file,
    path    => "${kafka_bi::params::kafka_bi_base_dir}/config/consumer_bi-${name}.properties",
    mode    => '0644',
    #content => template("kafka_bi/${::kafka_bi::params::consumer_bi_template}.erb"),
    content => template($kafka_bi::params::consumer_bi_template),
  } ->

  file { "producer_bi-${name}.properties":
    ensure  => file,
    path    => "${kafka_bi::params::kafka_bi_base_dir}/config/producer_bi-${name}.properties",
    mode    => '0644',
    #content => template("kafka_bi/${::kafka_bi::params::producer_bi_template}.erb"),
    content => template($kafka_bi::params::producer_bi_template),
  } ->

  file { "${kafka_bi::params::kafka_bi_base}/config/mirrormaker_bi_log4j.properties-${name}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template($kafka_bi::params::mirrormaker_bi_log4j_template),
  } ->

    service { "mirrormaker_bi-${name}":
      ensure    => $service_running,
      enable    => $kafka_bi::params::mirrormaker_bi_service_enable,
      subscribe => [ File["mirrormaker_bi-consumer-${name}", "mirrormaker_bi-producer-${name}", "mirrormaker_bi.init-${name}" ], Package['kafka_bi'] ],
      require   => [ File["mirrormaker_bi-consumer-${name}", "mirrormaker_bi-producer-${name}", "mirrormaker_bi.init-${name}" ] ],
    } ->

  jmxtrans::metrics { "mirrormaker_bi-jmxtrans-${name}":
    #jmx                  => "localhost:${jmx_port}-${jmx_port + $num_procs - 1}",
    jmx                  => "localhost:${jmx_port}-${jmx_port + 1}",
    #graphite_root_prefix => "${::domain_short}.${::hostname}_${::domain_short}.mirrormaker-${cluster}-jmx",
    graphite_root_prefix => "${::domain_short}.${::hostname}_${::domain_short}.mirrormaker-${::kafka_cluster_id}-jmx",
    graphite_host        => hiera('jmxtrans::graphite_host', 'graphite-in.sjc2.turn.com'),
    opentsdb_host        => hiera('jmxtrans::opentsdb_host', 'pipeline.dwh.turn.com'),
    opentsdb_tags        => { 'cluster'       => "kafka-bi${::kafka_cluster_id}",
                              'class'         => 'mirrormaker_bi',
                              'machine_class' => $::machine_class
    },
    jmxtrans_template    => $kafka_bi::params::mirrormaker_bi_jmxtrans_template,
  }

}
