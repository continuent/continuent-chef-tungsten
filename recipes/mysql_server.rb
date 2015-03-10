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
unless node['platform'] =~ /(?i:centos|redhat|oel|amazon|debian|ubuntu)/
	fail "The mysql_server recipe is not supported on an #{node['platform']}-based system."
end

package "mysql-server" do
	action :install
end

directory "/etc/mysql" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

directory "/etc/mysql/conf.d" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

template node['tungsten']['mysqlConfigFile'] do
  mode 00644
  source "tungsten_my_cnf.erb"
  owner "root"
  group "root"
  action :create
end

service_name = 'mysqld'
if node.platform_family?('debian') then
  service_name = 'mysql'
end

service "mysqld" do
  service_name service_name
  action :start
end

group "mysql" do
	action :manage
	append true
	members node['tungsten']['systemUser']
end

execute "tungsten_set_mysql_admin_password" do
  command "mysqladmin -u#{node['tungsten']['mysqlAdminUser']} password #{node['tungsten']['mysqlAdminPassword']}"
  only_if	{ "/usr/bin/test -f /usr/bin/mysql" && "/usr/bin/mysql -u {node['tungsten']['mysqlAdminUser']}" }
end
