# === Copyright
#
# Copyright 2014 Continuent Inc.
#
# === License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and 
# limitations under the License.
#

template "/etc/tungsten/tungsten.ini" do
	owner node['tungsten']['systemUser']
	group node['tungsten']['systemUser']
	mode 00644
	action :create
	only_if { File.directory?("/etc/tungsten") }
	source "tungsten_ini.erb"
end

directory node['tungsten']['backupDir'] do
  owner node['tungsten']['systemUser']
  group node['tungsten']['systemUser']
  mode 0755
  action :create
  recursive true
end

remote_file "#{Chef::Config['file_cache_path']}/#{node['tungsten']['clusterSoftware']}" do
	source "#{node['tungsten']['clusterSoftwareSource']}#{node['tungsten']['clusterSoftware']}"
	owner node['tungsten']['systemUser']
	group node['tungsten']['systemUser']
	mode 00644
  checksum node['tungsten']['clusterSoftwareChecksum']
	action :create_if_missing
end

package "TungstenClusterRPM" do
	action :install
	source "#{Chef::Config['file_cache_path']}/#{node['tungsten']['clusterSoftware']}"
	provider Chef::Provider::Package::Rpm
	only_if { File.exists?("#{Chef::Config['file_cache_path']}/#{node['tungsten']['clusterSoftware']}") }
end

execute "installTungstenCluster" do
	# works, but forces examination of log file upon error
	#command "sudo -i -u #{node['tungsten']['systemUser']} #{node['tungsten']['homeDir']}/software/#{node['tungsten']['clusterSoftwareDir']}/tools/tpm update -i --tty --log=/opt/continuent/service_logs/tungsten-configure.log > /opt/continuent/service_logs/rpm.output 2>&1"

	# works, displays error text upon failure, does not create a log file
	command "sudo -i -u #{node['tungsten']['systemUser']} #{node['tungsten']['homeDir']}/software/#{node['tungsten']['clusterSoftwareDir']}/tools/tpm update --tty"

	## doesn't work
	#command "sudo -i -u #{node['tungsten']['systemUser']} #{node['tungsten']['homeDir']}/software/#{node['tungsten']['clusterSoftwareDir']}/tools/tpm update -i --tty 2>&1 | tee /opt/continuent/service_logs/tungsten-configure.log"
end

=begin
file "/tmp/#{node['tungsten']['clusterSoftware']}" do
        action :delete
end
=end

