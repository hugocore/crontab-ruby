require_relative '../lib/resolver'

RSpec.describe Resolver do
  def build_cron_args(min, hour, day, month, day_week, cmd)
    {
      min: min,
      hour: hour,
      day: day,
      month: month,
      day_week: day_week,
      cmd: cmd
    }
  end

  describe '.call' do
    it 'converts an cron argument into valid cron values' do
      input = build_cron_args('*/15', '0', '1,15', '*', '1-5', '/usr/bin/find')

      response = Resolver.call(input)

      expected = {
        min: [0, 15, 30, 45],
        hour: [0],
        day: [1, 15],
        month: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        day_week: [1, 2, 3, 4, 5],
        cmd: '/usr/bin/find'
      }

      expect(response).to eq(expected)
    end

    context 'every hour, on the hour, from 9 A.M. through 6 P.M., every day' do
      subject { '0 9-18 * * * /home/carl/hourly-archive.sh'.split(/\s/) }

      it 'returns cron values' do
        response = Resolver.call(build_cron_args(*subject))

        expected = {
          min: [0],
          hour: (9..18).to_a,
          day: (1..31).to_a,
          month: (1..12).to_a,
          day_week: (0..7).to_a,
          cmd: '/home/carl/hourly-archive.sh'
        }

        expect(response).to eq(expected)
      end
    end

    context 'every Monday, at 9 A.M. and 6 P.M' do
      subject { '0 9,18 * * 1 /home/wendy/script.sh'.split(/\s/) }

      it 'returns cron values' do
        response = Resolver.call(build_cron_args(*subject))

        expected = {
          min: [0],
          hour: [9, 18],
          day: (1..31).to_a,
          month: (1..12).to_a,
          day_week: [1],
          cmd: '/home/wendy/script.sh'
        }

        expect(response).to eq(expected)
      end
    end

    context 'run on January 2 at 6:15 A.M' do
      subject { '15 6 2 1 * /home/melissa/backup.sh'.split(/\s/) }

      it 'returns cron values' do
        response = Resolver.call(build_cron_args(*subject))

        expected = {
          min: [15],
          hour: [6],
          day: [2],
          month: [1],
          day_week: (0..7).to_a,
          cmd: '/home/melissa/backup.sh'
        }

        expect(response).to eq(expected)
      end
    end

    context 'run every 5 minutes' do
      subject { '*/5 * * * * /var/bin/do-update.sh'.split(/\s/) }

      it 'returns cron values' do
        response = Resolver.call(build_cron_args(*subject))

        expected = {
          min: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55],
          hour: (0..23).to_a,
          day: (1..31).to_a,
          month: (1..12).to_a,
          day_week: (0..7).to_a,
          cmd: '/var/bin/do-update.sh'
        }

        expect(response).to eq(expected)
      end
    end

    context 'run every 5 minutes during the first half hour of every hour' do
      subject { '0-30/5 * * * * /var/bin/do-update.sh'.split(/\s/) }

      it 'returns cron values' do
        response = Resolver.call(build_cron_args(*subject))

        expected = {
          min: [0, 5, 10, 15, 20, 25, 30],
          hour: (0..23).to_a,
          day: (1..31).to_a,
          month: (1..12).to_a,
          day_week: (0..7).to_a,
          cmd: '/var/bin/do-update.sh'
        }

        expect(response).to eq(expected)
      end
    end
  end
end
