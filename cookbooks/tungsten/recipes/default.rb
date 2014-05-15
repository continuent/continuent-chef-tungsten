
file "/tmp/tungsten_install.log" do
  owner "ec2-user"
  group "ec2-user"
  mode 00644
  action :create
  content "
>> Variables
	system_profile	= #{node[:system_profile]}
	filesystem	= #{node[:filesystem]}
	platform	= #{node[:platform]}
	platform_family	= #{node[:platform_family]}
	os		= #{node[:os]}
	os_version	= #{node[:os_version]}
	ec2		= #{node[:ec2]}
	installNTP	= #{node[:tungsten][:installNTP]}
	setupSSHDirectory = #{node[:tungsten][:setupSSHDirectory]}
	disableSELinux	= #{node[:tungsten][:disableSELinux]}
	rootHome	= #{node[:tungsten][:rootHome]}
"
end

include_recipe "tungsten::prereq"
include_recipe "tungsten::mysql_server" if node[:tungsten][:installMysqlServer] == true
include_recipe "tungsten::cluster"
