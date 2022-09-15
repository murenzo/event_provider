require 'pry'

class EventProvider
  @events = {}

  class << self
    def subscribe(event_name:, handler_name:, &block)
      event_key = event_name.to_sym
      handler_key = handler_name.to_sym

      unless event_registered?(event_key)
        events[event_key] = { handler_key => block }
        return
      end

      events[event_key].store(handler_key, block)
    end

    def unsubscribe(event_name:, handler_name:)
      event_key = event_name.to_sym
      handler_key = handler_name.to_sym

      if event_handlers_count(event_name: event_key) > 1
        events[event_key].delete(handler_key)
        return
      end

      events.delete(event_key)
    end

    def registered_events_count
      events.keys.count
    end

    def event_handlers_count(event_name:)
      events[event_name].keys.count
    end

    def clear_events
      events.clear
    end

    private

    attr_reader :events

    def event_registered?(event_name)
      events.keys.any? { |key| key == event_name }
    end
  end
end
