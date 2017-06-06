# route53 cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/route53.svg?branch=master)](https://travis-ci.org/chef-cookbooks/route53) [![Cookbook Version](https://img.shields.io/cookbook/v/route53.svg)](https://supermarket.chef.io/cookbooks/route53)

Updates Amazon Web Service's Route 53 (DNS) service.

Amazon Route 53 can be used as DNS for any registered domain name. This cookbook provides a single resource `route53_record` that allows you to create or delete records.

## Requirements

### Platforms

- all platforms where the aws-sdk works

### Chef

- Chef 12.9+

### Cookbooks

- none

## Usage

```ruby
route53_record "create a record" do
  name  "test"
  value "16.8.4.2"
  type  "A"

  # The following are for routing policies
  weight "1" (optional)
  set_identifier "my-instance-id" (optional-must be unique)
  zone_id               node[:route53][:zone_id]
  aws_access_key_id     node[:route53][:aws_access_key_id]
  aws_secret_access_key node[:route53][:aws_secret_access_key]
  overwrite true
  fail_on_error false (set to true to report failure to Chef)
  action :create
end
```

NOTE: If you do not specify aws credentials, it will attempt to use the AWS IAM Role assigned to the instance instead.

```ruby
kitchen converge
```

## Resources Overview

### route53_record

#### Parameters

- `name` Required. String. - name of the domain or subdomain.
- `value` String Array - value appropriate to the `type`.. for type 'A' value would be an IP address in IPv4 format for example.
- `type` Required. String [DNS record type](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/ResourceRecordTypes.html)
- `ttl` Integer default: 3600 - time to live, the amount of time in seconds to cache information about the record
- `weight` Optional. String. - a value that determines the proportion of DNS queries that will use this record for the response. Valid options are between 0-255\. NOT CURRENTLY IMPLEMENTED
- `set_identifier` Optional . String. - a value that uniquely identifies record in the group of weighted record sets
- `geo_location` String.
- `geo_location_country` String
- `geo_location_continent` String
- `geo_location_subdivision` String
- `set_identifier` String
- `zone_id` String
- `aws_access_key_id` String
- `aws_secret_access_key` String
- `aws_region` String default: 'us-east-1'
- `overwrite` [true false] default: true
- `alias_target` Optional. Hash. - [Associated with Amazon 'alias' type records. The hash contents varies depending on the type of target the alias points to.](http://docs.aws.amazon.com/Route53/latest/APIReference/API_AliasTarget.html)
- `mock` [true false] default: false
- `fail_on_error` [true false] default: false

## ChefSpec Matcher

This Cookbook includes a [Custom Matcher](http://rubydoc.info/github/sethvargo/chefspec#Testing_LWRPs) for testing the **route53_record** LWRP with [ChefSpec](http://rubydoc.info/github/sethvargo/chefspec#Testing_LWRPs).

To utilize this Custom Matcher use the following test your spec:

```ruby
expect(chef_run).to create_route53_record('example.com')
```

## Development Notes

A useful reference for the structure of the AWS route53 requests: <http://docs.aws.amazon.com/Route53/latest/APIReference/API_ChangeResourceRecordSets_Requests.html#API_ChangeResourceRecordSets_RequestBasicSyntax>

And the relevant AWS-SDK doc: <http://docs.aws.amazon.com/sdkforruby/api/Aws/Route53/Client.html#change_resource_record_sets-instance_method>

## License & Authors

```text
Copyright:: 2011-2016, Heavy Water Software
Copyright:: 2016-2017, Chef Software

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
