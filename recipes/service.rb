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

template '/etc/init.d/tungsten' do
  owner 'root'
  mode 0755
  source 'tungsten.init.d.erb'
  variables({
    :user => node['tungsten']['systemUser'],
    :path => "#{node['tungsten']['homeDir']}/tungsten/cluster-home/bin"
  })
end

execute 'chkconfig --add tungsten && chkconfig --level 2345 tungsten on'