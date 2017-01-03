module SchemaPlus::PgTypes
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQL
        module ColumnMethods
          def interval(*args, **options)
            args.each { |name| column(name, :interval, options) }
          end
        end

        module Table
          include ColumnMethods
        end

        module TableDefinition
          include ColumnMethods
        end
      end
    end
  end
end