#
# Cookbook:: SickRage
# Library:: helpers
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
#
module SickRageCookbook
  require 'chef/mixin/shell_out'
  # Python
  module Python
    def install_python_depends
      case node['platform']
      when 'centos', 'fedora'
        yumgroup 'Development tools' do
          action :install
        end
        # package_list = ['git', 'zlib-devel', 'bzip2-devel', 'openssl-devel', 'ncurses-devel', 'sqlite-devel', 'xz', 'xz-devel']
        package_list = %w(git zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel xz xz-devel)
      when 'debian', 'ubuntu', 'linuxmint'
        build_essential 'python_reqs' do
          action :install
        end
        # package_list = ['git', 'libssl-dev', 'zlib1g-dev', 'libncurses5-dev', 'libncursesw5-dev', 'libreadline-dev', 'libsqlite3-dev', 'libgdbm-dev', 'libdb5.3-dev', 'libbz2-dev', 'libexpat1-dev', 'liblzma-dev']
        package_list = %w(git libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev
                          libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev)
      end

      package_list.each do |pkg|
        package pkg do
          action :install
        end
      end
    end

    def python_installed
      File.exist?("#{new_resource.install_path}/bin/python#{new_resource.p_version}")
    end

    def pip_installed
      File.exist?("#{new_resource.install_path}/bin/pip#{new_resource.p_version}")
    end

    def download_python_package
      remote_file "/opt/Python-#{new_resource.version}.tar.xz" do
        source "#{new_resource.python_url}/#{new_resource.version}/Python-#{new_resource.version}.tar.xz"
        owner 'root'
        group 'root'
        mode '0644'
        action :create
        only_if { !File.exist?("#{new_resource.install_path}/bin/python#{new_resource.p_version}") || new_resource.upgrade }
      end
    end

    def compile_python
      bash 'install_python' do
        user 'root'
        cwd '/opt'
        code <<-MAKE_PYTHON
        tar -xJf Python-#{new_resource.version}.tar.xz
        cd Python-#{new_resource.version}
        ./configure #{new_resource.opts} && make && make altinstall
        cd .. && rm -rf Python-*
        MAKE_PYTHON
        action :run
        only_if { !File.exist?("#{new_resource.install_path}/bin/python#{new_resource.p_version}") || new_resource.upgrade }
      end
    end

    def install_pip_package
      bash 'pip_install' do
        user 'root'
        cwd '/opt'
        code <<-GET_PIP
        curl -sO https://bootstrap.pypa.io/get-pip.py
        #{new_resource.install_path}/bin/python#{new_resource.p_version} get-pip.py
        rm -f get-pip.py
        GET_PIP
        action :run
        only_if { new_resource.install_pip && !File.exist?("#{new_resource.install_path}/bin/pip#{new_resource.p_version}") }
      end
    end
  end
  # Firewalls
  module Firewalls
    def check_firewalld_rule
      shell_out!('firewall-cmd --reload')
      get_zone = shell_out!('firewall-cmd --get-default-zone')
      zone = get_zone.stdout.chomp
      get_service = shell_out("firewall-cmd --permanent --zone=#{zone} --query-service=sickrage")
      sr_service = get_service.stdout.chomp
      shell_out!("firewall-cmd --permanent --zone=#{zone} --add-service=sickrage") if sr_service == 'no'
      shell_out!('firewall-cmd --reload') if sr_service == 'no'
    end

    def check_ipt_rule
      check_rule = shell_out("iptables -C INPUT -p tcp -m tcp --dport #{new_resource.port} -m conntrack --ctstate NEW -j ACCEPT; echo $?")
      rule_exists = check_rule.stdout.chomp
      rule_exists != '0' && shell_out!("iptables -A INPUT -p tcp -m tcp --dport #{new_resource.port} -m conntrack --ctstate NEW -j ACCEPT")
    end

    def check_ufw_rule
      %w(openssh sickrage).each do |services|
        check_rule = shell_out!('ufw status')
        check_rule.stdout =~ /^#{services}/
        next if check_rule.stdout.empty?
        shell_out!("ufw allow #{services}")
        shell_out!('ufw', 'enable', input: 'yes')
        shell_out!('ufw reload')
      end
    end
  end
end
