For overall testing guidelines see:

<https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/TESTING.MD>

# AWS Specific TESTING

As this cookbook modifies resources in AWS, it must be tested in AWS. This introduces some complexity, and also cost. The cookbook includes a test recipe and a kitchen config that runs in Vagrant, but uses the resource to create Route53 resources in AWS. It expects the following environmental variables to be set:

- AWS_ZONE_ID (optional)
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
