require_relative 'service'

class Parser
  extend Service

  def initialize(cron_string)
    @cron_string = cron_string
  end

  def call
    puts @cron_string
  end
end
