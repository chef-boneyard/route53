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

node.normal['build-essential']['compiletime'] = true
include_recipe "build-essential"

if node['platform_family'] == 'debian'
   xml = package "libxml2-dev" do
      action :nothing
   end
   xml.run_action( :install )

   xslt = package "libxslt1-dev" do
      action :nothing
   end
   xslt.run_action( :install )
elsif node['platform_family'] == 'rhel'
   xml = package "libxml2-devel" do
      action :nothing
   end
   xml.run_action( :install )

   xslt = package "libxslt-devel" do
      action :nothing
   end
   xslt.run_action( :install )
end

chef_gem "fog" do
  action :install
end

require 'rubygems'
Gem.clear_paths
