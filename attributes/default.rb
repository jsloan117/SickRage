#
# Cookbook Name:: SickRage
#
# Copyright 2018, Jonathan Sloan, GPL v3
#
default['sickrage']['createuser'] = true
default['sickrage']['user'] = 'sickrage'
default['sickrage']['group'] = 'sickrage'
default['sickrage']['comment'] = 'SickRage user'
default['sickrage']['shell'] = '/sbin/nologin'
default['sickrage']['systemuser'] = true
default['sickrage']['listen_port'] = 8081
default['sickrage']['nice_value'] = 0
default['sickrage']['directory']['install_dir'] = '/opt/sickrage'
default['sickrage']['directory']['data_dir'] = '/opt/sickrage'
default['sickrage']['directory']['config_dir'] = '/opt/sickrage'
default['sickrage']['directory']['pid_dir'] = '/opt/sickrage'
default['sickrage']['binary'] = "#{node['sickrage']['directory']['install_dir']}/SickBeard.py"

# Use firewall frontends (Firewalld/UFW) if true, if false use iptables
default['firewall']['use_frontend'] = true

# Python >= 2.7.10
default['python']['url'] = 'http://www.python.org/ftp/python'
default['python']['prefix'] = '/usr/local'
default['python']['version'] = '2.7.15'
default['python']['pversion'] = '2.7'
default['python']['binary'] = "#{default['python']['prefix']}/bin/python#{default['python']['pversion']}"
default['python']['configure_options'] = "--prefix=#{default['python']['prefix']} --enable-optimizations"
default['python']['upgrade'] = false
default['python']['pip'] = false
default['python']['pip_binary'] = "#{default['python']['prefix']}/bin/pip#{default['python']['pversion']}"

# Git Options
default['git']['url'] = 'https://github.com/SickChill/SickChill.git'
default['git']['revision'] = 'master'

# Get from running this command: git ls-remote https://github.com/SickChill/SickChill.git master
# default['git']['reference'] = '0e727649748ec38c5bba69f3f97c9e7b794d56df'
