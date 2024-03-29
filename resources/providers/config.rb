# Cookbook Name:: rbsocial
#
# Provider:: config
#

action :add do
  begin
    config_dir = new_resource.config_dir
    social_nodes = new_resource.social_nodes
    memory = new_resource.memory
    zk_hosts = new_resource.zk_hosts

    yum_package "redborder-social" do
      action :upgrade
      flush_cache[:before]
    end

    directory config_dir do #/etc/redborder-social
      owner "root"
      group "root"
      mode '755'
      action :create
    end

    template "/etc/redborder-social/config.yml" do
      source "rb-social_config.yml.erb"
      cookbook "rbsocial"
      owner "root"
      group "root"
      mode '0644'
      retries 2
      variables( :zk_hosts => zk_hosts, :nodes => social_nodes)
      notifies :restart, 'service[redborder-social]', :delayed
      action :create
    end

    template "/etc/sysconfig/redborder-social" do
      source "rb-social_sysconfig.erb"
      cookbook "rbsocial"
      owner "root"
      group "root"
      mode '0644'
      retries 2
      variables(:memory => memory)
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


action :register do #Usually used to register in consul
  begin
    if !node["rb-social"]["registered"]
      query = {}
      query["ID"] = "rb-social-#{node["hostname"]}"
      query["Name"] = "rb-social"
      query["Address"] = "#{node["ipaddress"]}"
      query["Port"] = 443
      json_query = Chef::JSONCompat.to_json(query)

      execute 'Register service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/register -d '#{json_query}' &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.set["rb-social"]["registered"] = true
    end
    Chef::Log.info("rb-social service has been registered in consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :deregister do #Usually used to deregister from consul
  begin
    if node["rb-social"]["registered"]
      execute 'Deregister service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/deregister/rb-social-#{node["hostname"]} &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.set["rb-social"]["registered"] = false
    end
    Chef::Log.info("rb-social service has been deregistered from consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end
