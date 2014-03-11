source "https://rubygems.org"

gem 'emeril', :group => :release

group :integration do
  gem "test-kitchen"
  gem "kitchen-vagrant"
  gem "kitchen-docker"
  gem "librarian-chef"
end

group :test do
  gem "chefspec", "~> 3.2.0"
  gem "fog", :git => 'https://github.com/josacar/fog.git', :branch => 'bug/fix-route53-empty-recordset'
  gem "berkshelf"
end
