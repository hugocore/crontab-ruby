require_relative 'service'

class Reporter
  extend Service

  def initialize(cron_values)
    @cron_values = cron_values
  end

  def call
    print "minute\t\t#{@cron_values[:min].join(' ')}\n" \
          "hour\t\t#{@cron_values[:hour].join(' ')}\n" \
          "day of month\t#{@cron_values[:day].join(' ')}\n" \
          "month\t\t#{@cron_values[:month].join(' ')}\n" \
          "day_week\t#{@cron_values[:day_week].join(' ')}\n" \
          "cmd\t\t#{@cron_values[:cmd]}\n"
  end
end
