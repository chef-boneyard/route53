require 'fog/aws/dns'
require 'yaml'

class Fog::DNS::AWS::Mock
  def self.data=(value)
    @data = value
  end
end

class FogMock
  MOCK_FILE = File.join(File.dirname(__FILE__), 'mock-route53-data.yml')
  MOCK_DATA = YAML.load_file(MOCK_FILE)
  def self.load_data
    Fog::DNS::AWS::Mock.data = MOCK_DATA
  end

  def self.reset
    Fog::Mock.reset
  end
end

shared_context 'route53' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(:step_into => ['route53_record'])
    runner.converge(described_recipe)
  end
  let(:domain) { 'example.com.' }
  before(:all) do
    Fog.mock!
  end
  before do
    FogMock.load_data
  end
  after do
    FogMock.reset
  end

  def route53_client
    Fog::DNS.new(provider: 'AWS', aws_access_key_id: 'AWS_ACCESS_KEY', aws_secret_access_key: 'AWS_SECRET_ACCESS_KEY')
  end

  def route53_zone
    route53_client.zones.detect { |zone| zone.domain == domain}
  end

  def create_record_to_update
    route53_zone.records.create({name: "existing.#{domain}", type: 'A', value: '2.2.2.2', ttl: 3600})
  end

  def create_record_to_do_not_delete
    route53_zone.records.create({name: domain, type: 'NS', value: '1.2.3.4', ttl: 3600})
  end

  def create_domain_data
    route53_client.zones.create({domain: domain})
  end
end
