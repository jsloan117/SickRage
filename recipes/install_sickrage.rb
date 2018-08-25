#
# Cookbook:: SickRage
# Recipe:: install_SickRage
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
#
user node['sickrage']['user'] do
  comment node['sickrage']['comment']
  home node['sickrage']['directory']['install_dir']
  shell node['sickrage']['shell']
  system node['sickrage']['systemuser']
  action :create
  only_if { node['sickrage']['createuser'] }
end

node['sickrage']['directory'].each do |_name, value|
  directory value do
    owner node['sickrage']['user']
    group node['sickrage']['group']
    mode '0750'
    action :create
  end
end

install_python 'python_setup' do
  version node['python']['version']
  install_path node['python']['prefix']
  opts node['python']['configure_options']
  upgrade node['python']['upgrade']
  install_pip node['python']['pip']
  p_version node['python']['pversion']
  action :install
end

git node['sickrage']['directory']['install_dir'] do
  repository node['git']['url']
  revision node['git']['revision']
  action :sync
end

template '/etc/systemd/system/sickrage.service' do
  source '_systemd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

template '/etc/firewalld/services/sickrage.xml' do
  source '_firewalld.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  only_if { node['firewall']['use_frontend'] && %w(centos fedora).include?(node['platform']) }
end

template '/etc/ufw/applications.d/sickrage' do
  source '_ufw.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  only_if { node['firewall']['use_frontend'] && %w(debian linuxmint ubuntu).include?(node['platform']) }
end

setup_firewall 'firewall_setup' do
  port node['sickrage']['listen_port']
  services 'sickrage'
  sysfw node['firewall']['use_frontend']
  action :create
end

execute "chown -R #{node['sickrage']['user']}:#{node['sickrage']['group']} #{node['sickrage']['directory']['install_dir']}"
execute "find #{node['sickrage']['directory']['install_dir']} -type d ! -perm 0750 -exec chmod 0750 {} \\;"
execute "find #{node['sickrage']['directory']['install_dir']} -type f ! -perm 0640 -exec chmod 0640 {} \\;"
execute "chmod 0750 #{node['sickrage']['binary']}"

service 'sickrage' do
  action [:enable, :start]
end
