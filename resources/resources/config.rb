#Cookbook Name :: rbsocial
#
# Resource:: config
#

actions :add, :remove , :register, :deregister
default_action :add

attribute :config_dir, :kind_of => String, :default => "/etc/redborder-social"
attribute :zk_hosts, :kind_of => String
attribute :social_nodes, :kind_of => Array, :default => []
attribute :memory, :kind_of => Fixnum, :default => 0

