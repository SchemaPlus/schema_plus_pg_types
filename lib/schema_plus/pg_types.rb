require 'schema_plus/core'

require_relative 'pg_types/version'

# Load any mixins to ActiveRecord modules, such as:
#
#require_relative 'pg_types/active_record/base'

# Load any middleware, such as:
#
# require_relative 'pg_types/middleware/model'

SchemaMonkey.register SchemaPlus::PgTypes
