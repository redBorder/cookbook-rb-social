#Cookbook Name :: rbsocial
#
# Resource:: config
#

actions :add, :register, :deregister, :remove
default_action :add

attribute :config_dir, :kind_of => String, :default => "/etc/redborder-social"
attribute :kafka_topic, :kind_of => String, :default => "rb_social"
attribute :name, :kind_of => String, :default => "localhost"
attribute :ip, :kind_of => String, :default => "127.0.0.1"
