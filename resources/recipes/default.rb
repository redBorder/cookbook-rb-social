#
# Cookbook Name:: rbsocial
# Recipe:: default
#
# redborder
#
#

rbsocial_config "config" do
  name node["hostname"]
  action :add
end
