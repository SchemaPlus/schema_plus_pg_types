require 'active_record/connection_adapters/postgresql_adapter'
require_relative 'oid/interval'
require_relative 'schema_statements'

module SchemaPlus::PgTypes
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQLAdapter
        include PostgreSQL::SchemaStatements

        def configure_connection
          super

          # Set interval output format to ISO 8601 for ease of parsing by ActiveSupport::Duration.parse
          execute('SET intervalstyle = iso_8601', 'SCHEMA')
        end

        def initialize_type_map(m)
          super(m)
          m.register_type 'interval' do |*_, sql_type|
            precision = extract_precision(sql_type)
            ::ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Interval.new(precision: precision)
          end
        end
      end
    end
  end
end

::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:interval] = { name: 'interval' }

