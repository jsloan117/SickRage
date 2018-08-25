#
# Cookbook:: SickRage
# Recipe:: default
#
# Copyright:: 2018,  Jonathan Sloan
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Cookbook:: SickRage
# Recipe:: default
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
#
error = ''

def recipe_list
  include_recipe 'yum-epel'
  include_recipe 'yumgroup'
  include_recipe 'SickRage::install_sickrage'
end

if node['platform'] == 'centos' && node['platform_version'].to_i >= 7
  recipe_list
elsif node['platform'] == 'debian' && node['platform_version'].to_i >= 8
  recipe_list
elsif node['platform'] == 'fedora' && node['platform_version'].to_i >= 27
  recipe_list
elsif node['platform'] == 'linuxmint' && node['platform_version'].to_i >= 17
  recipe_list
elsif node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 16.04
  recipe_list
else
  error = 'Please use a supported OS and version'
end
raise error unless error.empty?
