class EventProvider
  @events = {}

  class << self
    def registered_events_count
      @events.keys.count
    end
  end
end
