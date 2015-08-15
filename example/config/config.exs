use Mix.Config

# The configuration defined here will only affect the dependencies
# in the apps directory when commands are executed from the umbrella
# project. For this reason, it is preferred to configure each child
# application directly and import its configuration, as done below.
import_config "../apps/*/config/config.exs"

# Sample configuration (overrides the imported configuration above):
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
