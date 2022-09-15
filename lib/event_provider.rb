require 'pry'
require_relative 'event_provider_helper'

# frozen_string_literal: true

# EventProvider class used to manage events and their handlers.
class EventProvider
  @events = {}

  class << self
    include EventProviderHelper

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

    def broadcast(*options, event_name:)
      event_key = event_name.to_sym
      broadcasted_messages = []

      events[event_key].values.each do |proc|
        broadcasted_messages << proc.call(options)
      end

      broadcasted_messages
    end

    private

    attr_reader :events

    def event_registered?(event_name)
      events.keys.any? { |key| key == event_name }
    end
  end
end
