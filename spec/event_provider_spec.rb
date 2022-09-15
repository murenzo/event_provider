require_relative '../lib/event_provider'

describe EventProvider do
  it 'has zero events registered by default' do
    expect(EventProvider.registered_events_count).to eq(0)
  end
end
