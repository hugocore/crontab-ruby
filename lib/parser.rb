require_relative 'service'

# Parses the input and breaks each temporal argument into an hash,
# E.g. for this cron input "*/15 0 1,15 * 1-5 /usr/bin/find"
#
# > {
#   min: '*/15',
#   hour: '0',
#   day: '1,15',
#   month: '*',
#   day_week: '1-5',
#   cmd: '/usr/bin/find'
# }
class Parser
  extend Service

  MINUTES_INDEX = 0
  HOUR_INDEX = 1
  DAY_INDEX = 2
  MONTH_INDEX = 3
  DAY_WEEK_INDEX = 4
  COMMAND = 5

  def initialize(cron_string)
    @cron_string = cron_string
  end

  def call
    cron_args = @cron_string.split(/[\s\t]/)

    if (cron_args.size != 6)
      puts 'ERROR: The given input does not follow the correct format.'
      puts "The valid format it's: [minute] [hour] [day of month] [month] [day of week] [command]"
      puts 'E.g. "*/15 0 1,15 * 1-5 /usr/bin/find"'

      return
    end

    # TODO: Validate each argument with RegExps

    {
      min: cron_args[MINUTES_INDEX],
      hour: cron_args[HOUR_INDEX],
      day: cron_args[DAY_INDEX],
      month: cron_args[MONTH_INDEX],
      day_week: cron_args[DAY_WEEK_INDEX],
      cmd: cron_args[COMMAND]
    }
  end
end
