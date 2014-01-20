#
# Cookbook Name:: route53
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
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
include_recipe 'apt'

if node['platform_family'] == 'debian'
  %w{build-essential libxslt-dev libxml2-dev}.each do |pkg|
    p = package pkg do
      action :nothing
    end
    p.run_action(:install) 
  end

elsif node['platform_family'] == 'rhel'
  %w{libxml2-devel libxslt-devel}.each do |pkg| 
    p = package pkg do
      action :nothing
    end
    p.run_action(:install) 
  end
end

chef_gem "fog" do
  action :install
end

require 'rubygems'
Gem.clear_paths
