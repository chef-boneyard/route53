name             'route53'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Providces resources for managing Amazon Route53 DNS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.2.1'

%w(ubuntu debian centos redhat amazon scientific fedora oracle freebsd windows suse opensuse opensuseleap).each do |os|
  supports os
end

source_url       'https://github.com/chef-cookbooks/route53'
issues_url       'https://github.com/chef-cookbooks/route53/issues'
chef_version '>= 12.1'
