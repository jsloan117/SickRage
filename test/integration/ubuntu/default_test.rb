# Inspec test for recipe SickRage::default - Linuxmint/Ubuntu

describe os[:family] do
  it { should eq 'debian' }
end

describe service('ufw') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# FIXME: This is failing due to the qouting of text.
describe iptables(chain: 'ufw-user-input') do
  it { should have_rule("-A ufw-user-input -p tcp -m tcp --dport 8081 -m comment --comment \"'dapp_SickRage'\" -j ACCEPT") }
end

describe host('10.0.2.15', port: 8081, protocol: 'tcp') do
  it { should be_reachable }
  it { should be_resolvable }
end

describe user('sickrage') do
  it { should exist }
  its('uid') { should be > 100 }
  its('uid') { should be < 1000 }
  its('gid') { should be > 100 }
  its('gid') { should be < 1000 }
  its('group') { should eq 'sickrage' }
  its('home') { should eq '/opt/sickrage' }
  its('shell') { should eq '/sbin/nologin' }
end

describe directory('/opt/sickrage') do
  it { should exist }
  its('type') { should eq :directory }
  its('owner') { should eq 'sickrage' }
  its('group') { should eq 'sickrage' }
end

describe file('/opt/sickrage/SickBeard.py') do
  it { should exist }
  its('type') { should eq :file }
  its('owner') { should eq 'sickrage' }
  its('group') { should eq 'sickrage' }
  its('mode') { should cmp '0750' }
end

describe file('/etc/systemd/system/sickrage.service') do
  it { should exist }
  its('type') { should eq :file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
end

describe file('/etc/ufw/applications.d/sickrage') do
  it { should exist }
  its('type') { should eq :file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
end

describe systemd_service('sickrage') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port('8081') do
  it { should be_listening }
  its('protocols') { should cmp 'tcp' }
end

describe file('/usr/local/bin/python2.7') do
  it { should exist }
  its('type') { should eq :file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end
