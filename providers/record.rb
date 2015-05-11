
def name
  @name ||= begin
    return new_resource.name + '.' if new_resource.name !~ /\.$/
    new_resource.name
  end
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

def overwrite?
  @overwrite ||= new_resource.overwrite
end

def mock?
  @mock ||= new_resource.mock
end

def zone_id
  @zone_id ||= new_resource.zone_id
end

def route53
  @route53 ||= begin
    if mock?
      @route53 = Aws::Route53::Client.new(stub_responses: true)
    elsif new_resource.aws_access_key_id && new_resource.aws_secret_access_key
      @route53 = Aws::Route53::Client.new(
        access_key_id: new_resource.aws_access_key_id,
        secret_access_key: new_resource.aws_secret_access_key,
        region: new_resource.aws_region
      )
    else
      Chef::Log.info "No AWS credentials supplied, going to attempt to use automatic credentials from IAM or ENV"
      @route53 = Aws::Route53::Client.new(
        region: new_resource.aws_region
      )
    end
  end
end

def resource_record_set
  {
    name: name,
    type: type,
    ttl: ttl,
    resource_records:
      value.sort.map{|v| {value: v} }
  }
end

def current_resource_record_set
  # List all the resource records for this zone:
  lrrs = route53.
    list_resource_record_sets(
      hosted_zone_id: "/hostedzone/#{zone_id}",
      start_record_name: name
    )

  # Select current resource record set by name
  current = lrrs[:resource_record_sets].
    select{ |rr| rr[:name] == name }.first

  # return as hash, converting resource record
  # array of structs to array of hashes
  if current
    {
      name: current[:name],
      type: current[:type],
      ttl: current[:ttl],
      resource_records:
        current[:resource_records].sort.map{ |rrr| rrr.to_h }
    }
  else
    {}
  end
end

def change_record(action)
  begin
    request = {
      hosted_zone_id: "/hostedzone/#{zone_id}",
      change_batch: {
        comment: "Chef Route53 Resource: #{name}",
        changes: [
          {
            action: action,
            resource_record_set: resource_record_set
          },
        ],
      },
    }

    response = route53.change_resource_record_sets(request)
    Chef::Log.debug "Changed record - #{action}: #{response.inspect}"
  rescue Aws::Route53::Errors::ServiceError => e
    Chef::Log.error "Error with #{action}request: #{request.inspect} ::: "
    Chef::Log.error e.message
  end
end

action :create do
  require 'aws-sdk'

  if current_resource_record_set == resource_record_set
    Chef::Log.debug "Current resources match specification"
  else
    if overwrite?
      change_record "UPSERT"
      Chef::Log.info "Record created/modified: #{name}"
    else
      change_record "CREATE"
      Chef::Log.info "Record created: #{name}"
    end
  end
end

action :delete do
  require 'aws-sdk'

  if mock?
    # Make some fake data so that we can successfully delete when testing.
    mock_resource_record_set = {
      :name=>"pdb_test.example.com.",
      :type=>"A",
      :ttl=>300,
      :resource_records=>[{:value=>"192.168.1.2"}]
    }

    route53.stub_responses(
      :list_resource_record_sets,
      { resource_record_sets: [ mock_resource_record_set ] }
    )

  end

  if current_resource_record_set.nil?
    Chef::Log.info 'There is nothing to delete.'
  else
    change_record "DELETE"
    Chef::Log.info "Record deleted: #{name}"
  end
end
