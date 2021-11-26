#
# Cookbook Name:: rbsocial
# Recipe:: default
#
# redborder
#
#

rbsocial_config "config" do
  name node["hostname"]
  log_level 7
  action :add
end
