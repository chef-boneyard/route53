route53_record 'example.com' do
  type 'A'
  value '1.1.1.1'

  zone_id               'zone-ebfca8d6'
  aws_access_key_id     'AWS_ACCESS_KEY'
  aws_secret_access_key 'AWS_SECRET_ACCESS_KEY'
end
