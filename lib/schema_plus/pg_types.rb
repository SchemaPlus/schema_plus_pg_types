require 'schema_plus/core'

require_relative 'pg_types/active_record/connection_adapters/postgresql/adapter'
require_relative 'pg_types/active_record/connection_adapters/postgresql/schema_statements'
require_relative 'pg_types/active_record/connection_adapters/postgresql/column_methods'
require_relative 'pg_types/active_support/duration_fixes'
require_relative 'pg_types/version'

# Load any mixins to ActiveRecord modules, such as:
#
#require_relative 'pg_types/active_record/base'

# Load any middleware, such as:
#
# require_relative 'pg_types/middleware/model'

SchemaMonkey.register SchemaPlus::PgTypes
