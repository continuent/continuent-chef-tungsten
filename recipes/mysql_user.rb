

template "#{node[:tungsten][:rootHome]}/.my.cnf" do
  mode 00600
  source "tungsten_root_my_cnf.erb"
  owner "root"
  group "root"
  action :create
end

template "#{Chef::Config[:file_cache_path]}/tungsten_create_mysql_users.sh" do
  mode 00700
  source "tungsten_create_mysql_users.erb"
  owner "root"
  group "root"
  action :create
  only_if { File.exists?("#{node[:tungsten][:rootHome]}/.my.cnf") }
end

execute "tungsten_create_mysql_users" do
  command "#{Chef::Config[:file_cache_path]}/tungsten_create_mysql_users.sh"
  only_if { File.exists?("#{node[:tungsten][:rootHome]}/.my.cnf") }
end

execute "removeAnonUsers" do
  command "/usr/bin/mysql --defaults-file=#{node[:tungsten][:rootHome]}/.my.cnf -Be \"delete from mysql.user where user='';flush privileges;\""
  only_if	{ File.exists?("#{node[:tungsten][:rootHome]}/.my.cnf") && "/usr/bin/test -f /usr/bin/mysql" && "/usr/bin/test `/usr/bin/mysql --defaults-file=#{node[:tungsten][:rootHome]}/.my.cnf -Be \"select * from mysql.user where user='';\"|wc -l` -gt 0" }
end
