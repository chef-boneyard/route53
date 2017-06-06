# route53 Cookbook CHANGELOG

This file is used to list changes made in each version of the route53 cookbook.

## 2.0.0 (2017-06-06)

- Convert to a custom resource and use gem install in metadata to install the aws-sdk. This cookbook now requires Chef 12.9 or later
- Fix resource to properly converge and support why-run mode

## 1.2.2 (2017-06-06)

- Test with Local Delivery instead of Rake
- Documentation update, removal of duplicate attributes
- Update Apache license string in metadata
- Simplify true/false in the readme
- respond_to?(:) for < 12.6 compat

## 1.2.1 (2017-01-24)

- Remove apt from the berksfile as it’s not actually used
- Fix typo that caused a failure in the resource
- Add a better description of this cookbook in the metadata
- Add basic platforms to the metadata to aid in Supermarket searches
- Expand the testing doc to explain the AWS-isms

## 1.2.0 (2017-01-21)

- Adds fail_on_error option to the resource

## 1.1.1 (2016-12-19)
- Fix the authentication when an IAM role is attached to an EC2 instance

## 1.1.0 (2016-09-21)
- Fix current_resource_record_set and add alias_target data
- Remove chef 11 compat in chef_gem resource

## 1.0.0 (2016-09-16)

- Require Chef 12.1+
- Add ability to set weight and set_identifier so you can use a weighted
- Refactor to use the AWS gem instead of fog
- LWRP now auto installs the gem if it's not present. No need for the default recipe
- Add use_inline_resources to the provider
- Fixed wrong number of arguments bug.
- Remove librarian cheffile
- Add license file
- Add testing, contributing, and maintainers docs
- Change from Heavywater Software to Chef Software
- Add chef_version metadata
- Update Test Kitchen config
- Add standard testing Rakefile

## v0.4.4

- update for continued Chef 11 support
- .gitignore update

## v0.4.2

- fog version 1.37.0
- chef_gem compile_time false
- geo_location support

## v0.4.0

- make "name" the name_attribute of a resource
- depends on xml to support installing nokogiri and fog dependency

## v0.3.8

- allow for nokogiri version to be specified

## v0.3.6

- proper support for serverspec tests
- make sure needed resource defaults are required
- fog require error

## v0.3.5

- enhancements to supported TDD tools
- New Delete action available for record resource
- add aws secret token auth attribute support
- support mock record
- handle trailing dot on record names
- move nokogiri requires so they do not happen before chef_gem

## v0.3.4

- change to attribute names in the build-essential dependency cookbook

## v0.3.3

- support for alias records
- build-essential to correct fog build errors
- install specific fog version by setting attribute
- test-kitchen support and begin enhanced testing frameworks

## v0.3.2

- Add missing "name" attribute to metadata
- install correct libxml2 and libxslt package names for rhel family
- allow multiple MX records (or records in general), passed as array
- Added IAM role support
- Use chef_gem resource for fog install
- correct working record creation and overwrite logic
