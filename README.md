Description
===========

Updates Amazon Web Service's Route 53 (DNS) service.

Requirements
============

An Amazon Web Services account and a Route 53 zone.

Usage
=====

```ruby
include_recipe "route53"

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

  action :create
end
```
