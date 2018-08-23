#
# Cookbook:: SickRage
# Library:: SickRageCookbook::Helpers::Firewalls
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
#
# FIXME: Firewalld seems to not wanna start sometimes? The firewalld_check being executed thought?
#
module SickRageCookbook
  require 'chef/mixin/shell_out'
  # Helpers
  module Helpers
    # Firewalls
    module Firewalls
      def service_state(name, state)
        case state.to_s
        when 'enable'
          service name.to_s do
            action [:enable, :start]
          end
        when 'disable'
          service name.to_s do
            action [:disable, :stop]
          end
        end
      end

      def set_fw
        if new_resource.sysfw
          case node['platform']
          when 'centos', 'fedora'
            service_state('firewalld', 'enable')
            ruby_block 'check_firewalld' do
              block do
                check_firewalld_rule
              end
              action :run
            end
            # check_firewalld_rule
          when 'debian'
            check_ipt_rule
          when 'linuxmint', 'ubuntu'
            service_state('ufw', 'enable')
            check_ufw_rule
          end
        else
          case node['platform']
          when 'centos', 'fedora'
            service_state('firewalld', 'disable')
            check_ipt_rule
          when 'debian'
            check_ipt_rule
          when 'linuxmint', 'ubuntu'
            service_state('ufw', 'disable')
            check_ipt_rule
          end
        end
      end

      def check_firewalld_rule
        # TODO: See if I can loop though service w/ firewall-cmd like ufw
        shell_out!('firewall-cmd --reload')
        get_zone = shell_out!('firewall-cmd --get-default-zone')
        zone = get_zone.stdout.chomp
        get_service = shell_out("firewall-cmd --permanent --zone=#{zone} --query-service=#{new_resource.services}")
        sr_service = get_service.stdout.chomp
        shell_out!("firewall-cmd --permanent --zone=#{zone} --add-service=#{new_resource.services}") if sr_service == 'no'
        shell_out!('firewall-cmd --reload') if sr_service == 'no'
      end

      def check_ipt_rule
        apt_update
        apt_package 'iptables-persistent'
        check_rule = shell_out("iptables -C INPUT -p tcp -m tcp --dport #{new_resource.port} -m conntrack --ctstate NEW -j ACCEPT; echo $?")
        rule_exists = check_rule.stdout.chomp
        rule_exists != '0' && shell_out!("iptables -A INPUT -p tcp -m tcp --dport #{new_resource.port} -m conntrack --ctstate NEW -j ACCEPT")
      end

      def check_ufw_rule
        %W(openssh #{new_resource.services}).each do |service|
          check_rule = shell_out!('ufw status')
          check_rule.stdout =~ /^#{service}/
          next if check_rule.stdout.empty?
          shell_out!("ufw allow #{service}")
          # REVIEW: Believe I'm executing the enable & reload twice, only need once.
          shell_out!('ufw', 'enable', input: 'yes')
          shell_out!('ufw reload')
        end
      end
    end
  end
end
