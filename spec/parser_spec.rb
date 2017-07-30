require_relative '../lib/parser'

RSpec.describe Parser do
  describe '.call' do
    it 'breaks the given cron string into an hash with each temporal variable' do
      response = Parser.call('*/15 0 1,15 * 1-5 /usr/bin/find')

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
      it 'returns empty' do
        expect(Parser.call('*/15 0 1,15 * 1-5')).to be_nil
      end
    end
  end
end
