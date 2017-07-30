Dir[File.expand_path('lib/**/*.rb')].each do |f|
  require f
end

require 'pry'

cron_string = ARGV.first

class CronTab
  def initialize(cron_string)
    @context = cron_string
  end

  def parse()
    return unless @context

    @context = Parser.call(@context)

    self
  end

  def resolve
    return unless @context

    @context = Resolver.call(@context)

    self
  end

  def report
    return unless @context

    @context = Reporter.call(@context)

    self
  end
end

CronTab.new(cron_string)
  .parse()
  .resolve()
  .report()

Process.exit(0)
