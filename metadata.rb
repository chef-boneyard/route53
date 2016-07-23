name             'route53'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Installs/Configures route53'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.4'
source_url       'https://github.com/chef-cookbooks/route53' if respond_to?(:source_url)
issues_url       'https://github.com/chef-cookbooks/route53/issues' if respond_to?(:issues_url)

chef_version '>= 11.0' if respond_to?(:chef_version)
