# ==  Class kafka_bi::broker_bi_install.pp
# We create this class to be able to selectively install broker_bi on the desire locations

class kafka_bi::broker_bi_install {
  require '::kafka_bi::params'

  if $::kafka_bi::params::broker_bi_install == true {
    include '::kafka_bi::broker_bi'
    #include '::kafka_bi::test'
  }
  else {
    notice('skipping BROKER installation')
  }
}
