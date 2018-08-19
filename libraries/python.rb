#
# Cookbook:: SickRage
# Library:: SickRageCookbook::Helpers::Python
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
#
module SickRageCookbook
  require 'chef/mixin/shell_out'
  # Helpers
  module Helpers
    # Python
    module Python
      def install_python_depends
        case node['platform']
        when 'centos', 'fedora'
          yumgroup 'Development tools' do
            action :install
          end
          package_list = %w(git zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel xz xz-devel)
        when 'debian', 'ubuntu', 'linuxmint'
          apt_update
          build_essential 'python_reqs' do
            action :install
          end
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
  end
end
