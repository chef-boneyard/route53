action :create do
  require "fog"
  require "nokogiri"

  def name
    @name ||= new_resource.name + "."
  end

  def value
    @value = []
    if new_resource.value.kind_of?(Array)
      @value.concat(new_resource.value)
    else
      @value.push(Array)
    end
  end

  def type
    @type ||= new_resource.type
  end

  def ttl
    @ttl ||= new_resource.ttl
  end

  def overwrite
    @overwrite ||= new_resource.overwrite
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
      Chef::Log.info Nokogiri::XML( e.response.body ).xpath( "//xmlns:Message" ).text
    end
  end

  record = zone.records.get(name, type)

  if record.nil?
    create
    Chef::Log.info "Record created: #{name}"
  elsif ! value.sort.eql? record.value.sort
    unless overwrite == false
      record.destroy
      create
      Chef::Log.info "Record modified: #{name}"
    else
      Chef::Log.info "Record #{name} should have been modified, but overwrite is set to false."
      Chef::Log.debug "Current value: #{record.value.first}"
      Chef::Log.debug "Desired value: #{value}"
    end
  end

end
