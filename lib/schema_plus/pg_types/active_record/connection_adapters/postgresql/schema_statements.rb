require_relative 'oid/interval'

module SchemaPlus::PgTypes
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQL
        module SchemaStatements
          def type_to_sql(type, limit = nil, precision = nil, scale = nil)
            case type.to_s
              when 'interval'
                return super(type, limit, precision, scale) unless precision

                case precision
                  when 0..6; "interval(#{precision})"
                  else raise(ActiveRecordError, "No interval type has precision of #{precision}. The allowed range of precision is from 0 to 6")
                end
              else
                super(type, limit, precision, scale)
            end
          end
        end
      end
    end
  end
end


