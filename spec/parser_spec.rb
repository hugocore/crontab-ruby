require_relative '../lib/parser'

RSpec.describe Parser do
  describe '.call' do
    it 'breaks the given cron string into an hash with each temporal variable' do
      response = described_class.call('*/15 0 1,15 * 1-5 /usr/bin/find')

      expected = {
        min: '*/15',
        hour: '0',
        day: '1,15',
        month: '*',
        day_week: '1-5',
        cmd: '/usr/bin/find'
      }

      expect(response).to eq(expected)
    end

    it 'treats multiple spaces and tabs as one' do
      response = described_class.call('*/15  0   1,15 *       1-5 /usr/bin/find')

      expected = {
        min: '*/15',
        hour: '0',
        day: '1,15',
        month: '*',
        day_week: '1-5',
        cmd: '/usr/bin/find'
      }

      expect(response).to eq(expected)
    end

    context 'with an incomplete cron string' do
      subject { '*/15 0 1,15 * 1-5' }

      it 'raises exception' do
        expect do
          described_class.call(subject)
        end.to raise_error(ArgumentError)
      end
    end
  end
end
