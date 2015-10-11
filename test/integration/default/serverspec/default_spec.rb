require 'spec_helper'

describe package('build-essential'), if: os[:family] == 'debian' do
  it { should be_installed }
end

describe package('libxml2-dev'), if: os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('libxslt1-dev'), if: os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('libxml2-devel'), if: os[:family] == 'rhel' do
  it { should be_installed }
end

describe package('libxslt1-devel'), if: os[:family] == 'rhel' do
  it { should be_installed }
end

describe command('/opt/chef/embedded/bin/gem list') do
  its(:stdout) { should match(/fog/) }
end
