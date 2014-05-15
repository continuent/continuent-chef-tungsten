template "/etc/tungsten/tungsten.ini" do
	owner node[:tungsten][:systemUser]
	group node[:tungsten][:systemUser]
	mode 00644
	action :create
	only_if { File.directory?("/etc/tungsten") }
	source "tungsten_ini.erb"
end

cookbook_file "/tmp/#{node[:tungsten][:clusterSoftware]}" do
	source node[:tungsten][:clusterSoftware]
	owner node[:tungsten][:systemUser]
	group node[:tungsten][:systemUser]
	mode 00644
	action :create_if_missing
end

package "TungstenClusterRPM" do
	action :install
	source "/tmp/#{node[:tungsten][:clusterSoftware]}"
	provider Chef::Provider::Package::Rpm
	only_if { File.exists?("/tmp/#{node[:tungsten][:clusterSoftware]}") }
end

execute "installTungstenCluster" do
	# works, but forces examination of log file upon error
	#command "sudo -i -u #{node[:tungsten][:systemUser]} #{node[:tungsten][:homeDir]}/software/#{node[:tungsten][:clusterSoftwareDir]}/tools/tpm update -i --tty --log=/opt/continuent/service_logs/tungsten-configure.log > /opt/continuent/service_logs/rpm.output 2>&1"

	# works, displays error text upon failure, does not create a log file
	command "sudo -i -u #{node[:tungsten][:systemUser]} #{node[:tungsten][:homeDir]}/software/#{node[:tungsten][:clusterSoftwareDir]}/tools/tpm update --tty"

	## doesn't work
	#command "sudo -i -u #{node[:tungsten][:systemUser]} #{node[:tungsten][:homeDir]}/software/#{node[:tungsten][:clusterSoftwareDir]}/tools/tpm update -i --tty 2>&1 | tee /opt/continuent/service_logs/tungsten-configure.log"
end

=begin
file "/tmp/#{node[:tungsten][:clusterSoftware]}" do
        action :delete
end
=end

