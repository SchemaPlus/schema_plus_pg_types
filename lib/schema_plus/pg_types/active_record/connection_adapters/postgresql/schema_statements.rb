require_relative 'oid/interval'

module SchemaPlus::PgTypes
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQL
        module SchemaStatements
          def type_to_sql(type, limit = nil, precision = nil, scale = nil, array = nil)
            case type.to_s
              when 'interval'
                sql = 'interval'
                if precision
                  sql << case precision
                    when 0..6; "(#{precision})"
                    else raise(::ActiveRecord::ActiveRecordError, "No interval type has precision of #{precision}. The allowed range of precision is from 0 to 6")
                  end
                end
                sql << '[]' if array
                sql
              else
                super(type, limit, precision, scale)
            end
          end
        end
      end
    end
  end
end


