#
# Cookbook Name:: sensu_master
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'
require 'yaml'

describe 'route53_test::default' do
  context 'When using test-kitchen attributes, on an unspecified platform' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['route53'] = YAML.load(<<-END_ROUTE53)
          zone_id: <%= ENV['AWS_ZONE_ID'] || 'Z2DEMODEMODEMO' %>
          aws_access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
          aws_secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
          aws_region: <%= ENV['AWS_REGION'] %>
        END_ROUTE53

        node.set['records'] = YAML.load(<<-END_RECORDS)
          generic_record:
            name: 'kitchen-test.yourdomain.org'
            value: '16.8.4.3'
            type: 'A'
            ttl: 3600
          alias_record:
            name: 'kitchen-test-alias.yourdomain.org'
            alias_target:
              dns_name: 'dns-name'
              hosted_zone_id: 'host-zone-id'
            type: 'A'
            run: true
          END_RECORDS
      end.converge(described_recipe)
    end

    it 'should install the aws-sdk gem' do
      expect(chef_run).to install_chef_gem('aws-sdk')
    end

    it 'should create route53 record' do
      expect(chef_run).to create_route53_record('kitchen-test.yourdomain.org')
    end

    it 'should create route53 alias record' do
      expect(chef_run).to create_route53_record('kitchen-test-alias.yourdomain.org')
    end

    it 'should delete route53 record' do
      expect(chef_run).to delete_route53_record('kitchen-test.yourdomain.org_delete')
    end
  end
end
