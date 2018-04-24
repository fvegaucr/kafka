# ==  Class kafka_bi::mirrormaker_bi_install.pp
# We create this class to be able to selectively install mirrormaker_bi on the desire locations

class kafka_bi::mirrormaker_bi_install {
  require '::kafka_bi::params'

  if $::kafka_bi::params::mirrormaker_bi_install == true {
    include '::kafka_bi::mirrormaker_bi'
    include '::kafka_bi::topics'
    #include '::kafka_bi::test'
  }
  else {
    notice('skipping MIRRORMAKER installation')
  }
}
