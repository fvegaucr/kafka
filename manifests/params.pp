# == Class kafka_bi::params
# Some of the parameters that are used to config different elements of the cluster
class kafka_bi::params (

# User and Group Settings
  $uid                                   = 657,
  $user                                  = 'kafka_bi',
  $user_description                      = 'Kafka BI system account',
  $user_ensure                           = 'present',
  $user_home                             = '/home/kafka_bi',
  $user_manage                           = true,
  $user_managehome                       = false,
  $gid                                   = 657,
  $group                                 = 'kafka_bi',
  $group_ensure                          = 'present',
  $shell                                 = '/bin/bash',
  $hostname                              = undef,
  $limits_manage                         = true,
  $limits_nofile                         = 65536,

# zookeeper config information
  $zookeeper_connection_timeout_ms       = 30000,
  $zookeeper_session_timeout_ms          = 30000,
  $zookeeper_connect                     = ['localhost:2181'],
  $zk_chroot                             = '',

# Package Installation and Version
  $kafka_bi_base_dir                     = '/opt/kafka_bi',
  $kafka_bi_package                      = 'kafka_bi',
  $kafka_bi_package_version              = '0.10.2',
  $kafka_bi_package_iteration            = '1',
  $kafka_bi_dest_cluster                 = 'aggregate_bi',

# broker config variables
  $broker_bi_install                     = false,
  $brokerid_map                          = {},
  $config_map                            = {},
  $kafka_bi_broker_port                  = 9092,
  $kafka_bi_broker_config_template       = 'kafka_bi/server.properties.erb',
  $kafka_bi_logging_config_template      = 'kafka_bi/kafka_bi_log4j.properties.erb',
  $num_network_threads                   = 3,
  $num_io_threads                        = $::processorcount,
  $num_partitions                        = 2,
  $log_retention_hours                   = 168,
  $log_roll_hours                        = 1,
  $num_replica_fetchers                  = 8,
  $auto_create_topics_enable             = true,
  $default_replication_factor            = 2,
  $auto_leader_rebalance_enable          = true,
  $socket_send_buffer_bytes              = 102400,
  $socket_receive_buffer_bytes           = 32768,
  $socket_request_max_bytes              = 104857600,
  $delete_topic_enable                   = true,
  $bootstrap_servers                     = [],
  $send_buffer_bytes                     = 102400,
  $receive_buffer_bytes                  = 32768,
  $log_segment_bytes                     = 1073741824,
  $log_retention_check_interval_ms       = 300000,
  $num_recovery_threads_per_data_dir     = 1,
  $offsets_topic_num_partitions          = 2,

# Script Variables -- Broker
  $kafka_bi_broker_service_name          = 'kafka_bi_broker',
  $kafka_bi_java_home                    = '/usr/java/jdk1.8.0_60',
  $kafka_bi_class                        = 'kafka.kafka',
  $kafka_bi_gc_log_file                  = "${kafka_bi_embedded_log_dir}/daemon-gc.log",
  $kafka_bi_gc_log_opts                  = '-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps',
  $kafka_bi_heap_opts                    = '-Xmx256M',
  $kafka_bi_broker_num_procs             = 1,


# Jmx Variables  -- Broker
  $jmx_port                              = 9999,
  $kafka_bi_jmx_opts                     = '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false',
  $kafka_bi_jmxtrans_template_broker     = 'kafka_bi_v_10.2',

# Java Options/Variables -- Broker
  $kafka_bi_jvm_performance_opts         = '-server -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true',

# Log and File Variables
  $kafka_bi_log4j_opts                   = undef,
  $kafka_bi_opts                         = undef,
  $log_dirs                              = ['/server/turn/kafka_datalog'],

# Service Variables
  $service_autorestart                   = true,
  $service_enable                        = true,
  $service_ensure                        = 'present',
  $system_log_dir                        = '/var/log/kafka_bi',
  $service_manage                        = true,
  $tmpfs_manage                          = false,
  $tmpfs_path                            = '/tmpfs',
  $tmpfs_size                            = '0k',
  $service_retries                       = 999,
  $service_startsecs                     = 10,
  $service_stderr_logfile_keep           = 10,
  $service_stderr_logfile_maxsize        = '50MB',
  $service_stdout_logfile_keep           = 2,
  $service_stdout_logfile_maxsize        = '50MB',


# Mirrormaker Config Variables
# Install
  $mirrormaker_bi_install                = false,
  $mirrormaker_bi_log4j_template         = 'kafka_bi/mirrormaker_bi_log4j.properties.erb',
  $producer_bi_template                  = 'kafka_bi/producer_bi.properties.erb',
  $consumer_bi_template                  = 'kafka_bi/consumer_bi.properties.erb',
  $mirrormaker_bi_init_script_template   = 'kafka_bi/mirrormaker_bi.init.erb',
  $topiclist                             = 'test',

# Init Script Vars
  $mirrormaker_bi_num_procs              = 1,
  $mirrormaker_bi_num_streams            = 1,
  $mirrormaker_bi_service_name           = 'mirrormaker_bi',
  $mirrormaker_bi_java_home              = '/usr/java/jdk1.8.0_60',
  $mirrormaker_bi_gc_log_opts            = '-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps',
  $mirrormaker_bi_heap_opts              = '-Xmx256M',
  $mirrormaker_bi_log4j_opts             = undef,
  $mirrormaker_bi_opts                   = undef,
  $mirrormaker_bi_service_manage         = true,
  $mirrormaker_bi_service_enable         = true,

# Jmx Variables(mirrormaker)
  $mirrormaker_bi_jmx_port               = 10000,
  $mirrormaker_bi_jmx_opts               = '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false',
  $mirrormaker_bi_jmxtrans_template      = 'kafka_bi_mirrormaker_10.2',

# Java Options/Variables(mirrormaker)
  $mirrormaker_bi_jvm_performance_opts   = '-server -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true',

# Producer_bi properties Variables
  $producer_bi_bootstrap                 = [],
  $producer_bi_compression_type          = 'lz4',
  $producer_bi_acks                      = 'all',
  $producer_bi_batch_size                = 16384,
  $producer_bi_linger_ms                 = 0,
  $producer_bi_key_serializer            = 'org.apache.kafka.common.serialization.Serializer',
  $producer_bi_send_buffer_bytes         = 131072,
  $producer_bi_receive_buffer_bytes      = 32768,

# Consumer_bi properties Variables
  $consumer_bi_bootstrap                 = [],
  $consumer_bi_max_partition_fetch_bytes = 1048576,
  $consumer_bi_receive_buffer_bytes      = 65536,
  $consumer_bi_send_buffer_bytes         = 131072,
  $consumer_bi_group_id                  = '',
  $consumer_bi_key_deserializer          = 'org.apache.kafka.common.serialization.Deserializer',
  $consumer_bi_value_deserializer        = 'org.apache.kafka.common.serialization.Deserializer',
  $consumer_bi_fetch_min_bytes           = 1,
  $consumer_bi_fetch_max_bytes           = 52428800,
  $consumer_bi_fetch_max_wait_ms         = 500,
)
{

# directory configuration values
  $kafka_bi_config                       = "${kafka_bi_base_dir}/config/server.properties"
  $kafka_bi_embedded_log_dir             = "${kafka_bi_base_dir}/logs"
  $kafka_bi_logging_config               = "${kafka_bi_base_dir}/config/log4j.properties"

# mirrormaker -- maybe wont need 
  $producer_bi_mirror                    = "${kafka_bi_base_dir}/config/producer_bi.properties"
  $consumer_bi_mirror                    = "${kafka_bi_base_dir}/config/consumer_bi.properties"
  $mirrormaker_bi_log4j                  = "${kafka_bi_base_dir}/config/mirrormaker_bi_log4j.properties"
  $mirrormaker_bi_gc_log_file            = "${kafka_bi_embedded_log_dir}/mirrormaker_bi_daemon-gc.log"


  if has_key($brokerid_map, $::fqdn) and has_key($brokerid_map[$::fqdn], 'brokerid')
    { $broker_id = $brokerid_map[$::fqdn]['brokerid'] }
  else
    { $broker_id = -1 }

# VALIDATION

# user-groups
  if !is_integer($gid) { fail('The $gid parameter must be an integer number') }
  validate_string($group)
  validate_string($group_ensure)
  validate_string($hostname)
  if !is_integer($uid) { fail('The $uid parameter must be an integer number') }
  validate_string($user)
  validate_string($user_description)
  validate_string($user_ensure)
  validate_absolute_path($user_home)
  validate_bool($user_manage)
  validate_bool($user_managehome)

# Broker
  validate_bool($broker_bi_install)
  validate_absolute_path($kafka_bi_base_dir)
  if !is_integer($broker_id) { fail('The $broker_id parameter must be an integer number') }
  if !is_integer($kafka_bi_broker_port) { fail('The $broker_port parameter must be an integer number') }
  validate_absolute_path($kafka_bi_config)
  validate_string($kafka_bi_broker_config_template)
  if !is_integer($num_network_threads) { fail('The $num_network_threads parameter must be an integer number') }
  if !is_integer($num_io_threads) { fail('The $num_io_threads parameter must be an integer number') }
  if !is_integer($num_partitions) { fail('The $num_partitions parameter must be an integer number') }

# logs
  validate_absolute_path($kafka_bi_embedded_log_dir)
  validate_absolute_path($kafka_bi_gc_log_file)

  validate_array($log_dirs)
  validate_absolute_path($kafka_bi_logging_config)
  validate_string($kafka_bi_logging_config_template)
  validate_string($kafka_bi_log4j_opts)
  validate_absolute_path($system_log_dir)

# service
  validate_bool($service_autorestart)
  validate_bool($service_enable)
  validate_string($service_ensure)

# jmx
  if !is_integer($jmx_port) { fail('The $jmx_port parameter must be an integer number') }
  validate_string($kafka_bi_jmx_opts)

# java
  validate_string($kafka_bi_gc_log_opts)
  validate_string(kafka_bi_heap_opts)
  validate_string($kafka_bi_jvm_performance_opts)
  validate_string($kafka_bi_opts)

# files
  validate_bool($limits_manage)
  validate_string($hostname)
  if !is_integer($limits_nofile) { fail('The $limits_nofile parameter must be an integer number') }
  validate_bool($tmpfs_manage)
  validate_absolute_path($tmpfs_path)
  validate_string($tmpfs_size)

# package
  validate_string($kafka_bi_package_version)
  validate_string($kafka_bi_package_iteration)
  validate_string($kafka_bi_package)

# shell
  validate_absolute_path($shell)

# zookeeper
  validate_array($zookeeper_connect)
  validate_string($zk_chroot)

# mirrormaker
  validate_bool($mirrormaker_bi_install)

  case $::osfamily {
    'RedHat': {}

    default: {
      fail("The ${module_name} module is not supported on a ${::osfamily} based system.")
    }
  }
}
