require 'spec_helper'
require 'active_record/schema_dumper'

class Item < ActiveRecord::Base
end

class DefaultItem < ActiveRecord::Base

end

describe 'Migration' do

  let(:migration) { ActiveRecord::Migration }
  let(:connection) { ActiveRecord::Base.connection }
  let(:schema) { ActiveRecord::Schema }

  before(:each) do
    clear_tables
  end

  context 'INTERVAL data type' do
    it 'supports interval type' do
      sql = create_table_sql :items do |t|
        t.interval :duration
        t.integer :another_field
      end
      expect(sql).to match /"duration" interval/
    end

    it 'supports interval type with precision and array' do
      sql = create_table_sql :items do |t|
        t.interval :duration, precision: 5, array: true
      end
      expect(sql).to match /"duration" interval\(5\)\[\]/
    end

    it 'fails when precision is too high' do
      expect do
        create_table_sql :items do |t|
          t.interval :duration, precision: 10
        end
      end.to raise_error /No interval type has precision of 10/
    end
  end

  protected

  def clear_tables
    connection.data_sources.each do |table| connection.drop_table table, cascade: true end
  end

  class DummyConnectionAdapter < ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
    attr_reader :sql

    def initialize
      @connection          = nil
      @owner               = nil
      @instrumenter        = ActiveSupport::Notifications.instrumenter
      @logger              = nil
      @config              = {}
      @pool                = nil
      @quoted_column_names, @quoted_table_names = {}, {}
      @visitor             = arel_visitor
      @sql                 = []
    end

    def execute(sql)
      @sql << sql
    end
  end

  def create_table_sql(*args, **opts, &block)
    conn = DummyConnectionAdapter.new
    conn.create_table *args, **opts, &block
    conn.sql.join '; '
  end
end
