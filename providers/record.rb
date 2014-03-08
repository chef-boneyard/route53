action :create do

  require 'fog/aws/dns'
  require 'nokogiri'

  def aws
    {
    :provider => 'AWS',
    :aws_access_key_id => new_resource.aws_access_key_id,
    :aws_secret_access_key => new_resource.aws_secret_access_key
    }
  end

  def name
    @name ||= new_resource.name + "."
  end

  def value
    @value ||= Array(new_resource.value)
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

  def alias_target
    @alias_target ||= new_resource.alias_target
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
      zone(aws).records.create(record_attributes)
    rescue Excon::Errors::BadRequest => e
      Chef::Log.error Nokogiri::XML( e.response.body ).xpath( "//xmlns:Message" ).text
    end
  end

  def record_attributes
    common_attributes = { :name => name, :type => type }
    common_attributes.merge(record_value_or_alias_attributes)
  end

  def record_value_or_alias_attributes
    if alias_target
      { :alias_target => alias_target.to_hash }
    else
      { :value => value, :ttl => ttl }
    end
  end

  def same_record?(record)
    name.eql?(record.name) &&
      same_value?(record)
  end

  def same_value?(record)
    if alias_target
      same_alias_target?(record)
    else
      value.sort == record.value.sort
    end
  end

  def same_alias_target?(record)
    alias_target &&
      record.alias_target &&
      (alias_target['dns_name'] == record.alias_target['DNSName'].gsub(/\.$/,''))
  end

  record = zone(aws).records.get(name, type)

  if record.nil?
    create
    Chef::Log.info "Record created: #{name}"
  elsif !same_record?(record)
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
