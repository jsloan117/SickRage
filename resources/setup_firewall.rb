#
# Cookbook:: SickRage
# Resource:: setup_firewall
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
#
# TODO: Setup property for services
#
resource_name :setup_firewall

provides :setup_firewall, platform: 'centos' do |node|
  node['platform_version'].to_i >= 7
end
provides :setup_firewall, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end
provides :setup_firewall, platform: 'fedora' do |node|
  node['platform_version'].to_i >= 27
end
provides :setup_firewall, platform: 'linuxmint' do |node|
  node['platform_version'].to_i >= 17
end
provides :setup_firewall, platform: 'ubuntu' do |node|
  node['platform_version'].to_f >= 16.04
end

property :port, Integer
property :services, [Array, String]
property :sysfw, [true, false], default: true

default_action :nothing

action :create do
  set_fw
end

action_class do
  include SickRageCookbook::Helpers::Firewalls
end
