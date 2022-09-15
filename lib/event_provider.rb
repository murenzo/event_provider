require 'pry'

class EventProvider
  @events = {}

  class << self
    def registered_events_count
      events.keys.count
    end

    def event_handlers_count(event_name:)
      events[event_name].keys.count
    end

    def subscribe(event_name:, listener_name:, &block)
      event_key = event_name.to_sym
      listener_key = listener_name.to_sym

      unless event_registered?(event_key)
        events[event_key] = { listener_key => block }
        return
      end

      events[event_key].store(listener_key, block)
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
