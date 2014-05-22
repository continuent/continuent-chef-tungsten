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
