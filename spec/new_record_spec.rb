require 'spec_helper'

describe 'route53_test::new_record' do
  include_context 'route53'

  context 'with a no existing record with the same name' do
    it 'creates record' do
      chef_run
      record = route53_zone.records.detect { |r| r.name == 'name.example.com.' }
      expect(record).to be
      expect(record.type).to eq 'A'
      expect(record.value).to eq ['1.1.1.1']
    end
  end
end
