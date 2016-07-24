require 'spec_helper'

describe 'route53::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'should install the aws-sdk gem' do
      expect(chef_run).to install_chef_gem('aws-sdk')
    end
  end
end
