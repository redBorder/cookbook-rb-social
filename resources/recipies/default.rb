#
# Cookbook Name:: rbsocial
# Recipe:: default
#
# redborder
#
#

directory "etc/rb-social" do
  owner "root"
end

rbsocial_config "config" do
  name node["hostname"]
  log_level 7
  action :add
end
