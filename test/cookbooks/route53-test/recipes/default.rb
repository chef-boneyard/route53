#
# Cookbook Name:: route53-test
# Recipe:: default
#
# Copyright 2014, Heavy Water Operations
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['platform_family'] == 'debian'
  update_cache = execute "update apt" do
                  command "apt-get update"
                end
  update_cache.run_action( :run )
end

include_recipe "route53"

route53_record "create a test record" do
  name  "kitchen-test.yourdomain.org"
  value "16.8.4.3"
  type  "A"
  ttl   3600
  zone_id               node[:route53][:zone_id]
  aws_access_key_id     node[:route53][:aws_access_key_id]
  aws_secret_access_key node[:route53][:aws_secret_access_key]
  overwrite true
  action :create
end
