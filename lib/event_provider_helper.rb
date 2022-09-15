# frozen_string_literal: true

# Helper methods used by the EventProvider class
module EventProviderHelper
  def registered_events_count
    events.keys.count
  end

  def event_handlers_count(event_name:)
    events[event_name].keys.count
  end

  def clear_events
    events.clear
  end
end
