require 'active_support/duration'

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module OID # :nodoc:
        class Interval < Type::Value # :nodoc:
          def type
            :interval
          end

          def cast_value(value)
            case value
              when ::ActiveSupport::Duration
                value
              when ::String
                # Will raise +ActiveSupport::Duration::ISO8601Parser::ParsingError+ on string of unknown format
                ::ActiveSupport::Duration.parse(value)
              else
                super
            end
          end

          # Dump the ISO8601 date inside the schema
          def type_cast_for_schema(value)
            "\"#{value.iso8601}\""
          end

          def serialize(value)
            case value
              when ::ActiveSupport::Duration
                value.iso8601(precision: self.precision)
              when ::Numeric
                # Sometimes operations on Times returns just float number of seconds so we need to handle that.
                # Example: Time.current - (Time.current + 1.hour) # => -3600.000001776 (Float)
                duration = ::ActiveSupport::Duration.new(value.to_i, seconds: value.to_i)
                duration.iso8601(precision: self.precision)
              else
                super
            end
          end
        end
      end
    end
  end
end

