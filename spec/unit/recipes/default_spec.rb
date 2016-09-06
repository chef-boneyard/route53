require 'spec_helper'

describe 'default recipe' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(step_into: ['route53_record'])
    runner.converge('route53_test::default')
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
