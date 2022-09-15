require_relative '../lib/event_provider'
require 'pry'

describe EventProvider do
  it 'has zero events registered by default' do
    expect(EventProvider.registered_events_count).to eq(0)
  end

  describe '.subscribe' do

    after :each do
      EventProvider.clear_events
    end

    context 'when subscribing a handler to an event' do
      it 'registers an event alongside the handler' do
        EventProvider.subscribe(event_name: :order_created,
                                handler_name: :notify_customer) do |_|
          puts 'Notifying the customer that their order has been created'
        end

        expect(EventProvider.registered_events_count).to eq(1)
        expect(EventProvider.event_handlers_count(event_name: :order_created)).to eq(1)
      end
    end

    context 'when subscribing different handlers to different event' do
      it 'registers the events alongside their respective handler' do
        EventProvider.subscribe(event_name: :order_created,
                                handler_name: :notify_customer) do |_|
          puts 'Notifying the customer that their order has been created'
        end

        EventProvider.subscribe(event_name: :order_dispatched,
                                handler_name: :notify_customer) do |_|
          puts 'Notifying the customer that their order has been dispatched'
        end

        expect(EventProvider.registered_events_count).to eq(2)
        expect(EventProvider.event_handlers_count(event_name: :order_created)).to eq(1)
        expect(EventProvider.event_handlers_count(event_name: :order_dispatched)).to eq(1)
      end
    end

    context 'when subscribing multiple handlers to the same event' do
      it 'registers all handlers to the event' do
        EventProvider.subscribe(event_name: :order_created,
                                handler_name: :notify_customer) do |_|
          puts 'Notifying the customer that their order has been created'
        end

        EventProvider.subscribe(event_name: :order_created,
                                handler_name: :notify_admin) do |_|
          puts 'Notifying admin that an order has been placed'
        end

        expect(EventProvider.registered_events_count).to eq(1)
        expect(EventProvider.event_handlers_count(event_name: :order_created)).to eq(2)
      end
    end
  end

  describe '.unsubscribe' do
    context 'when event has only one handler' do
      it 'removes both handler and event from registered events' do
        EventProvider.subscribe(event_name: :order_created,
                                handler_name: :notify_customer) do |_|
          puts 'Notifying the customer that their order has been created'
        end

        EventProvider.unsubscribe(event_name: :order_created,
                                  handler_name: :notify_customer)

        expect(EventProvider.registered_events_count).to eq(0)
      end
    end

    context 'when event has more than one handler' do
      it 'removes only the handler from the event' do
        EventProvider.subscribe(event_name: :order_created,
                                handler_name: :notify_customer) do |_|
          puts 'Notifying the customer that their order has been created'
        end

        EventProvider.subscribe(event_name: :order_created,
                                handler_name: :notify_admin) do |_|
          puts 'Notifying admin that an order has been placed'
        end

        EventProvider.unsubscribe(event_name: :order_created, handler_name: :notify_admin)

        expect(EventProvider.registered_events_count).to eq(1)
        expect(EventProvider.event_handlers_count(event_name: :order_created)).to eq(1)
      end
    end
  end
end
