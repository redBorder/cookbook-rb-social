# Cookbook Name:: rbsocial
#
# Provider:: config
#

action :add do
  begin
    config_dir = new_resource.config_dir
    user = new.resource.user

    yum_package "redborder-social" do
      action :upgrade
      flush_cache[:before]
    end

    user user do
      action :create
    end

    directory config_dir do #/etc/redborder-social
      owner "root"
      group "root"
      mode 755
      action :create
    end


    template "etc/rb-social/config.yml" do
      source "rb-social_config.yml.erb"
      cookbook "rbsocial"
      owner "root"
      group "root"
      mode '0644'
      retries 2
      notifies :restart, 'service[redborder-social]', :delayed
    end

    template "etc/rb-social/sysconfig" do
      source "rb-social_sysconfig.erb"
      owner "root"
      group "root"
      mode '0644'
      retries 2
      notifies :restart, 'service[redborder-social]', :delayed
    end

    service "redborder-social" do
      service_name "redborder-social"
      ignore_failure true
      supports :status => true, :reload => true, :restart => true
      action [:enable, :start]
    end

    Chef::Log.info("cookbook redborder-social has been processed.")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    service "redborder-social" do
      service_name "redborder-social"
      supports :status => true, :restart => true, :start => true, :enable => true, :disable => true
      action [:disable, :stop]
    end
    Chef::Log.info("cookbook redborder-social has been processed.")
  rescue => e
    Chef::Log.error(e.message)
  end
end