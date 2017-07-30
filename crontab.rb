Dir[File.expand_path('lib/**/*.rb')].each do |f|
  require f
end

cron_string = ARGV.first

Parser.call(cron_string)
