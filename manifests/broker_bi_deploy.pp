# Broker configuration and deployment class
class kafka_bi::broker_bi_deploy {

  require '::kafka_bi::params'
  $kafka_bi_class  = $::kafka_bi::params::kafka_bi_class
  $service_name = $::kafka_bi::params::kafka_bi_broker_service_name

  if $kafka_bi::params::service_manage == true {

    $kafka_gc_log_opts_suffix = "-Xloggc:${kafka_bi::params::kafka_bi_gc_log_file}"
    if $kafka_bi::params::kafka_bi_gc_log_opts {
      $kafka_gc_log_opts_real = "KAFKA_GC_LOG_OPTS_PREP=\"${kafka_bi::params::kafka_bi_gc_log_opts} ${kafka_gc_log_opts_suffix}\""
    }
    else {
      $kafka_gc_log_opts_real = "KAFKA_GC_LOG_OPTS_PREP=\"${kafka_gc_log_opts_suffix}\""
    }

    if $kafka_bi::params::kafka_bi_heap_opts {
      $kafka_heap_opts_real = "KAFKA_HEAP_OPTS=\"${kafka_bi::params::kafka_bi_heap_opts}\""
    }
    else {
      $kafka_heap_opts_real = ''
    }

    if $kafka_bi::params::kafka_bi_jmx_opts {
      $kafka_jmx_opts_real = "KAFKA_JMX_OPTS=\"${kafka_bi::params::kafka_bi_jmx_opts}\""
    }
    else {
      $kafka_jmx_opts_real = ''
    }

    if $kafka_bi::params::kafka_bi_jvm_performance_opts {
      $kafka_jvm_performance_opts_real = "KAFKA_JVM_PERFORMANCE_OPTS=\"${kafka_bi::params::kafka_bi_jvm_performance_opts}\""
    }
    else {
      $kafka_jvm_performance_opts_real = ''
    }

    $kafka_log4j_opts_prefix = "-Dlog4j.configuration=file:${kafka_bi::params::kafka_bi_logging_config}"
    if $kafka_bi::params::kafka_bi_log4j_opts {
      $kafka_log4j_opts_real = "KAFKA_LOG4J_OPTS=\"${kafka_log4j_opts_prefix} ${kafka_bi::params::kafka_bi_log4j_opts}\""
    }
    else {
      $kafka_log4j_opts_real = "KAFKA_LOG4J_OPTS=\"${kafka_log4j_opts_prefix}\""
    }

    if $kafka_bi::params::kafka_bi_opts {
      $kafka_opts_real = "KAFKA_OPTS=\"${kafka_bi::params::kafka_bi_opts}\""
    }
    else {
      $kafka_opts_real = ''
    }
    if $kafka_bi::params::service_enable {
      $service_running = 'running'
    }
    else {
      $service_running = 'stopped'
    }

    $kafka_bi_environment="JMX_PORT=${kafka_bi::params::jmx_port} ${kafka_gc_log_opts_real} ${kafka_heap_opts_real} ${kafka_jmx_opts_real} ${kafka_jvm_performance_opts_real} ${kafka_log4j_opts_real} ${kafka_opts_real}"
    $kafka_bi_commandline=$::kafka_bi::params::kafka_bi_config

    file { 'kafka_init':
      ensure  => file,
      path    => "/etc/init.d/${kafka_bi::params::kafka_bi_broker_service_name}",
      mode    => '0755',
      content => template('kafka_bi/kafka_bi.init.erb'),
    }

    if $kafka_bi::params::service_enable == true {
      service { 'kafka_bi_broker':
        ensure    => $service_running,
        enable    => $kafka_bi::params::service_enable,
        #subscribe => [ File[$kafka_bi::params::kafka_bi_config], File['kafka_init'], Package['kafka_bi'] ],
        require   => File['kafka_init'],
      }
    }

  }

  # query kafka broker for its JMX metrics
  jmxtrans::metrics { 'kafka_bi':
    jmx                  => 'localhost:9999',
    graphite_root_prefix => "${::domain_short}.${::hostname}_${::domain_short}.kafka-${::kafka_cluster_id}-jmx",
    graphite_host        => hiera('jmxtrans::graphite_host', 'graphite-in.sjc2.turn.com'),
    opentsdb_host        => hiera('jmxtrans::opentsdb_host', 'pipeline.dwh.turn.com'),
    opentsdb_tags        => { 'cluster'       => "kafka_bi${::kafka_cluster_id}",
                              'class'         => 'kafka_bi_broker',
                              'machine_class' => $::machine_class,
    },
    jmxtrans_template    => $kafka_bi::params::kafka_bi_jmxtrans_template_broker,
  }

}
