module Rbsocial
  module Helpers

    def config_hash(resource)
      config = {}

      #CONF SECTION
      kafka_topic = resource["kafka_topic"]
      log_level = resource["log_level"]
      config["conf"] = {
        "debug" => log_level,
        "stdout" => 1,
        "syslog" => 0,
        "threads" => 1,
        "timeout" => 40,
        "max_snmp_fails" => 2,
        "max_kafka_fails" => 2,
        "sleep_main_thread" => 40,
        "sleep_worker_thread" => 5,
        "kafka_broker" => "kafka.service",
        "kafka_timeout" => 2,
        "kafka_topic" => kafka_topic
      }
      return config
      end
  end
end