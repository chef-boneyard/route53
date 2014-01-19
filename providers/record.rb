action :create do

require 'fog'
require 'nokogiri'

AWS = {
  :provider => 'AWS',
  :aws_access_key_id => new_resource.aws_access_key_id,
  :aws_secret_access_key => new_resource.aws_secret_access_key
  }

  def name
    @name ||= new_resource.name + "."
  end

  def value
    @value = []
    if new_resource.value.kind_of?(Array)
      @value.concat(new_resource.value)
    else
      @value.push(new_resource.value)
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

  def zone(connection_info)
    if new_resource.aws_access_key_id && new_resource.aws_secret_access_key
      @zone = Fog::DNS.new(connection_info).zones.get( new_resource.zone_id )
    else
      Chef::Log.info "No AWS credentials supplied, going to attempt to use IAM roles instead"
      @zone = Fog::DNS.new({ :provider => "AWS", :use_iam_profile => true }
                             ).zones.get( new_resource.zone_id )
    end
  end

  def create
    begin
    created = zone(AWS).records.create({ :name => name,
                            :value => value,
                            :type => type,
                            :ttl => ttl })
    rescue Excon::Errors::BadRequest => e
      Chef::Log.info Nokogiri::XML( e.response.body ).xpath( "//xmlns:Message" ).text
    end
  end

  record = zone(AWS).records.get(name, type)

  if record.nil?
    create
    Chef::Log.info "Record created: #{name}"
  elsif (name.eql? record.name) && (value.sort != record.value.sort)
    unless overwrite == false
      record.destroy
      create
      Chef::Log.info "Record modified: #{name}"
   else
      Chef::Log.info "Record #{name} should have been modified, but overwrite is set to false."
      Chef::Log.debug "Current value: #{record.value.first}"
      Chef::Log.debug "Desired value: #{value}"
    end
  else Chef::Log.info "There is nothing to update."
  end

end
