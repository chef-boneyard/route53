require 'spec_helper'

describe 'route53_test::existing_record_same_type' do
  include_context 'route53'

  context 'with an existing record with the same name and ttl same type' do
    it 'deletes existing record and creates new record' do
      create_record_to_update
      chef_run

      record = route53_zone.records.detect { |r| r.name == 'existing.example.com.' }
      expect(record.value).to eq ['1.1.1.1']
    end
  end
end
