
unless node[:platform] =~ /(?i:centos|redhat|oel|amazon|debian|ubuntu)/
	fail "The mysql_server recipe is not supported on an #{node[:platform]}-based system."
end

package "mysql-server" do
	action :install
end

template node[:tungsten][:mysqlConfigFile] do
	mode 00644
	source "tungsten_my_cnf.erb"
        owner "root"
        group "root"
        action :create
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

service "mysqld" do
	action :start
	only_if { File.exists?(node[:tungsten][:mysqlConfigFile]) }
end

group "mysql" do
	action :manage
	append true
	members node[:tungsten][:systemUser]
end

execute "tungsten_set_mysql_admin_password" do
	path ["/bin", "/usr/bin"]
        command "mysqladmin -u#{node[:tungsten][:mysqlAdminUser]} password #{node[:tungsten][:mysqlAdminPassword]}"
	only_if	{ "/usr/bin/test -f /usr/bin/mysql" && "/usr/bin/mysql -u {node[:tungsten][:mysqlAdminUser]}" }
end

template "#{node[:tungsten][:rootHome]}/.my.cnf" do
	mode 00600
	source "tungsten_root_my_cnf.erb"
        owner "root"
        group "root"
        action :create
	#not_if { File.exists?("#{node[:tungsten][:rootHome]}/.my.cnf") }
end

template "/tmp/tungsten_create_mysql_users" do
	mode 00700
	source "tungsten_create_mysql_users.erb"
        owner "root"
        group "root"
        action :create
	only_if { File.exists?("#{node[:tungsten][:rootHome]}/.my.cnf") }
end

execute "tungsten_create_mysql_users" do
        command "/tmp/tungsten_create_mysql_users"
	only_if { File.exists?("/tmp/tungsten_create_mysql_users") }
end

execute "removeAnonUsers" do
	command "/usr/bin/mysql --defaults-file=#{node[:tungsten][:rootHome]}/.my.cnf -Be \"delete from mysql.user where user='';flush privileges;\""
	only_if	{ File.exists?("#{node[:tungsten][:rootHome]}/.my.cnf") && "/usr/bin/test -f /usr/bin/mysql" && "/usr/bin/test `/usr/bin/mysql --defaults-file=#{node[:tungsten][:rootHome]}/.my.cnf -Be \"select * from mysql.user where user='';\"|wc -l` -gt 0" }
end
