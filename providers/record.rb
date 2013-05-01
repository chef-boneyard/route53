action :create do
  require "fog"
  require "nokogiri"

  def name
    @name ||= new_resource.name + "."
  end

  def value
    @value ||= new_resource.value
  end

  def type
    @type ||= new_resource.type
  end

  def ttl
    @ttl ||= new_resource.ttl
  end

  def zone
    @zone ||= Fog::DNS.new({ :provider => "aws",
                             :aws_access_key_id => new_resource.aws_access_key_id,
                             :aws_secret_access_key => new_resource.aws_secret_access_key }
                           ).zones.get( new_resource.zone_id )
  end

  def create
    begin
      zone.records.create({ :name => name,
                            :value => value,
                            :type => type,
                            :ttl => ttl })
    rescue Excon::Errors::BadRequest => e
      Chef::Log.warn Nokogiri::XML( e.response.body ).xpath( "//xmlns:Message" ).text
    end
  end

  record = zone.records.get(name, type)

  if record.nil?
    create
    Chef::Log.info "Record created: #{name}"
    new_resource.updated_by_last_action(true)
  elsif value != record.value.first
    record.destroy
    create
    Chef::Log.info "Record modified: #{name}"
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.info "Record unchanged: #{name}"
  end
end
