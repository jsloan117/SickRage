# SickRage Cookbook

![License](https://img.shields.io/badge/License-GPLv3-blue.svg)
[![Build Status](https://travis-ci.org/jsloan117/SickRage.svg?branch=dev)](https://travis-ci.org/jsloan117/SickRage)
[![Maintainability](https://api.codeclimate.com/v1/badges/73965b6fa7df316fd9ce/maintainability)](https://codeclimate.com/github/jsloan117/SickRage/maintainability)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fjsloan117%2FSickRage.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fjsloan117%2FSickRage?ref=badge_shield)

TODO: This cookbook is designed to install and allow you to configure sickrage a well maintained fork of sickbeard.

---

## Requirements

---

### Platforms Supported

- CentOS >= 7
- Debian >= 8
- Fedora >= 27
- Linuxmint >= 17
- Ubuntu >= 16.04

### Required Cookbooks

- yum-epel >= 3.2.0
- yumgroup >= 0.6.0

### Software

- Python >= 2.7.10
- Git >= 1.6.5

### Attributes

---

```ruby
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
```

| Attribute                                       | Value                                                                                               |
| ----------------------------------------------- |:---------------------------------------------------------------------------:|
| default['sickrage']['createuser']               | true                                                                        |
| default['sickrage']['user']                     | 'sickrage'                                                                  |
| default['sickrage']['group']                    | 'sickrage'                                                                  |
| default['sickrage']['comment']                  | 'SickRage user'                                                             |
| default['sickrage']['shell']                    | '/sbin/nologin'                                                             |
| default['sickrage']['systemuser']               | true                                                                        |
| default['sickrage']['listen_port']              | 8081                                                                        |
| default['sickrage']['nice_value']               | 0                                                                           |
| default['sickrage']['directory']['install_dir'] | '/opt/sickrage'                                                             |
| default['sickrage']['directory']['data_dir']    | '/opt/sickrage'                                                             |
| default['sickrage']['directory']['config_dir']  | '/opt/sickrage'                                                             |
| default['sickrage']['directory']['pid_dir']     | '/opt/sickrage'                                                             |
| default['sickrage']['binary']                   | "#{node['sickrage']['directory']['install_dir']}/SickBeard.py"              |
| default['firewall']['use_frontend']             | true                                                                        |
| default['python']['url']                        | '<http://www.python.org/ftp/python>'                                        |
| default['python']['prefix']                     | '/usr/local'                                                                |
| default['python']['version']                    | '2.7.15'                                                                    |
| default['python']['pversion']                   |  '2.7'                                                                      |
| default['python']['binary']                     | "#{default['python']['prefix']}/bin/python#{default['python']['pversion']}" |
| default['python']['configure_options']          | "--prefix=#{default['python']['prefix']} --enable-optimizations"            |
| default['python']['upgrade']                    | false                                                                       |
| default['python']['pip']                        | false                                                                       |
| default['python']['pip_binary']                 | "#{default['python']['prefix']}/bin/pip#{default['python']['pversion']}"    |
| default['git']['url']                           | '<https://github.com/SickChill/SickChill.git>'                                |
| default['git']['revision']                      | 'master'                                                                    |

## Usage

---

### SickRage::default

e.g.
Just include `SickRage` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[SickRage]"
  ]
}
```

## Resource Overview

### install_python

The `install_python` resource will compile python. The version attribute is required.

#### install_python actions

- `:install` - compiles the version of python specified.

| Attributes   | Description                                       | Example                            | Default                                    |
| ------------ |:-------------------------------------------------:|:----------------------------------:|:------------------------------------------:|
| install_path | path to install python at                         | /root                              | /usr/local                                 |
| install_pip  | whether or not to install pip package             | true                               | false                                      |
| opts         | compilation options                               | --prefix=/usr/local                | --prefix=/usr/local --enable-optimizations |
| p_version    | (required) major and minor version                | 2.7                                |                                            |
| python_url   | where to get the package from                     | <http://www.python.org/ftp/python> | <http://www.python.org/ftp/python>         |
| upgrade      | use to change versions                            | true                               | false                                      |
| version      | (name attribute) which version to compile/install | 2.7.15                             |                                            |

```ruby
install_python '2.7.15' do
  p_version '2.7'
  action :install
end

install_python 'python_setup' do
  install_path '/usr/local'
  install_pip false
  opts '--prefix=/usr/local --enable-optimizations'
  upgrade false
  version '2.7.15'
  p_version '2.7'
  action :install
end
```

### setup_firewall

The `setup_firewall` resource will create a firewall rule for a port number. Firewall frontends would be Firewalld/UFW,
if you put `sysfw` to `false` it will fall back to using `iptables` and will disable and stop Firewalld/UFW.

#### setup_firewall actions

- `:create` - adds a firewall rule to the default firewall used by the system.

| Attributes | Description                            | Example | Default |
| ---------- |:--------------------------------------:|:-------:|:-------:|
| port       | add rule for port number               | 8081    |         |
| services   | name of a firewalld/ufw service        | openssh |         |
| sysfw      | use firewall frontends                 | false   | true    |

```ruby
setup_firewall 'firewall_setup' do
  services 'sickrage'
  action :create
end

setup_firewall 'firewall_setup' do
  port 8081
  sysfw false
  action :create
end
```

### Authors & License

---

Authors: Jonathan Sloan

License: GPLv3.0


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fjsloan117%2FSickRage.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fjsloan117%2FSickRage?ref=badge_large)