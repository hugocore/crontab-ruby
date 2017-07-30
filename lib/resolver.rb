require_relative 'service'
require 'pry'

# Based on the rules from https://www.freebsd.org/cgi/man.cgi?crontab(5),
# this class figures out the valid cron values for each temporal axis of cron args,
# e.g. for this cron args
# {
#   min: '*/15',
#   hour: '0',
#   day: '1,15',
#   month: '*',
#   day_week: '1-5',
#   cmd: '/usr/bin/find'
# }
#
# > {
#   min: [0, 15, 30, 45],
#   hour: [0],
#   day: [1, 15],
#   month: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
#   day_week: [1, 2, 3, 4, 5],
#   cmd: '/usr/bin/find'
# }
class Resolver
  extend Service

  MINUTES = (0..59).to_a
  HOURS = (0..23).to_a
  DAYS = (1..31).to_a
  MONTHS = (1..12).to_a
  DAY_WEEK = (0..7).to_a

  RANGE_REGEXP = /-/
  SELECTION_REGEXP = /,/
  STEPS_REGEXP = /\//
  ALL_REGEXP = /\*/

  def initialize(cron_args)
    @cron_args = cron_args
  end

  def call()
    {
      min: resolve(MINUTES, @cron_args[:min]),
      hour: resolve(HOURS, @cron_args[:hour]),
      day: resolve(DAYS, @cron_args[:day]),
      month: resolve(MONTHS, @cron_args[:month]),
      day_week: resolve(DAY_WEEK, @cron_args[:day_week]),
      cmd: @cron_args[:cmd]
    }
  end

  private

  def resolve(options, cron_arg)
    cron_values = case cron_arg
      when STEPS_REGEXP
        resolve_steps(options, cron_arg)
      when RANGE_REGEXP
        resolve_range(cron_arg)
      when SELECTION_REGEXP
        resolve_selection(cron_arg)
      when ALL_REGEXP
        options
      else
        [cron_arg.to_i]
    end

    have_invalid_options = (cron_values - options).size > 0

    if (have_invalid_options)
      error = "ERROR: The argument '#{cron_arg}' it's not valid.\n" \
              "The available options are: #{options.join(', ')}"

      raise ArgumentError, error
    end

    cron_values
  end

  def resolve_range(cron_arg)
    range = cron_arg.split(RANGE_REGEXP)

    (range.first.to_i..range.last.to_i).to_a
  end

  def resolve_selection(cron_arg)
    cron_arg.split(SELECTION_REGEXP).map { |i| i.to_i }
  end

  def resolve_steps(options, cron_arg)
    step_args = cron_arg.split(STEPS_REGEXP)

    range_value = step_args.first
    step_value = step_args.last

    range = range_value == '*' ? options : resolve_range(range_value)

    range.select { |i| i % step_value.to_i == 0 }
  end
end
