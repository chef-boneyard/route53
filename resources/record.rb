actions :create, :delete
default_action :create

attribute :name,                        kind_of: String, required: true, name_attribute: true
attribute :value,                       kind_of: [String, Array]
attribute :type,                        kind_of: String, required: true
attribute :ttl,                         kind_of: Integer, default: 300
attribute :weight,                      kind_of: Integer
attribute :set_id,                      kind_of: String
attribute :geo_location,                kind_of: String
attribute :geo_location_country,        kind_of: String
attribute :geo_location_continent,      kind_of: String
attribute :geo_location_subdivision,    kind_of: String
attribute :set_identifier,              kind_of: String
attribute :zone_id,                     kind_of: String
attribute :aws_access_key_id,           kind_of: String
attribute :aws_secret_access_key,       kind_of: String
attribute :aws_region,                  kind_of: String, default: 'us-east-1'
attribute :overwrite,                   kind_of: [TrueClass, FalseClass], default: true
attribute :alias_target,                kind_of: Hash
attribute :mock,                        kind_of: [TrueClass, FalseClass], default: false
attribute :routing_policy,              kind_of: String, default: 'simple'
attribute :region,                      kind_of: String,
attribute :failover_record_type,        kind_of: String,
attribute :location,                    kind_of: String,
