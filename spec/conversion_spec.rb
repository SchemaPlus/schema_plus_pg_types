require 'spec_helper'
require 'active_record/schema_dumper'

class Item < ActiveRecord::Base
end

class DefaultItem < ActiveRecord::Base

end

describe 'Conversion' do

  let(:migration) { ActiveRecord::Migration }
  let(:connection) { ActiveRecord::Base.connection }
  let(:schema) { ActiveRecord::Schema }

  before(:each) do
    define_schema
  end

  context 'INTERVAL data type' do
    TEST_DURATIONS = [
      0.seconds,
      0.days,
      0.years,
      27.seconds,
      28.minutes,
      3.hours,
      15.days,
      3.weeks,
      2.months,
      1.year,
      5.years,
      5.years + 7.months + 10.days + 6.hours + 7.minutes + 8.seconds
    ]

    it 'should convert data from ActiveSupport::Duration (round trip)' do
      TEST_DURATIONS.each{|duration| Item.create(duration: duration)}
      durations = Item.pluck(:duration)
      expect(durations).to all(be_an(ActiveSupport::Duration))
      expect(durations).to eq(TEST_DURATIONS)
    end

    it 'should convert data to ActiveSupport::Duration' do
      connection.execute(<<~EOF
        INSERT INTO items (duration)
        VALUES
          ('0 seconds'),
          ('0'),
          ('0 years'),
          ('27 seconds'),
          ('28 minutes'),
          ('3 hours'),
          ('15 days'),
          ('3 weeks'),
          ('2 months'),
          ('1 year'),
          ('5 years'),
          ('5 years 7 months 10 days 6 hours 7 minutes 8 seconds');
      EOF
      )
      durations = Item.pluck(:duration)
      expect(durations).to all(be_an(ActiveSupport::Duration))
      expect(durations).to eq(TEST_DURATIONS)
    end

    it 'should support default values' do
      DefaultItem.create
      item_with_default_value = DefaultItem.first
      expect(item_with_default_value.duration).to be_an(ActiveSupport::Duration)
      expect(item_with_default_value.duration).to eq(2.years + 5.minutes)
    end

    it 'should properly dump the schema' do
      stream = StringIO.new
      ActiveRecord::SchemaDumper.dump(connection, stream)
    end

  end

  protected

  def define_schema
    connection.data_sources.each do |table| connection.drop_table table, cascade: true end

    schema.define do

      create_table :items, force: true do |t|
        t.interval :duration
      end

      create_table :default_items, force: true do |t|
        t.interval :duration, default: 2.years + 5.minutes
      end
    end
  end
end
