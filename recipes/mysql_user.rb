
template node[:tungsten][:mysqlConfigFile] do
  mode 00644
  source "tungsten_my_cnf.erb"
  owner "root"
  group "root"
  action :create
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
