#
# Cookbook:: SickRage
# Resource:: install_python
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
#
resource_name :install_python

provides :install_python, platform: 'centos' do |node|
  node['platform_version'].to_i >= 7
end
provides :install_python, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end
provides :install_python, platform: 'fedora' do |node|
  node['platform_version'].to_i >= 27
end
provides :install_python, platform: 'linuxmint' do |node|
  node['platform_version'].to_i >= 17
end
provides :install_python, platform: 'ubuntu' do |node|
  node['platform_version'].to_f >= 16.04
end

property :install_path, String, default: '/usr/local'
property :install_pip, [true, false], default: false
property :opts, String, default: '--prefix=/usr/local --enable-optimizations'
property :p_version, String, required: true
property :python_url, String, default: 'http://www.python.org/ftp/python'
property :upgrade, [true, false], default: false
property :version, String, name_property: true

default_action :install

# load_current_value do
#  current_value_does_not_exist! unless ::File.exist?("node.run_state['python']['binary']")
#  version node.run_state['python']['version']
# end

action :install do
  install_python_depends
  download_python_package
  compile_python
  install_pip_package
end

# action :install do
#  converge_if_changed do
#    install_python_depends
#    download_python_package
#    compile_python
#    install_pip_package
#  end
# end

action_class do
  include SickRageCookbook::Helpers::Python
end
