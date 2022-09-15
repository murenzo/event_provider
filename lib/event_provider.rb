require 'pry'
require_relative 'event_provider_helper'

# frozen_string_literal: true

# EventProvider class used to manage events and their handlers.
class EventProvider
  @events = {}

  class << self
    include EventProviderHelper

    def subscribe(event_name:, handler_name:, &block)
      unless event_registered?(symbolize(event_name))
        events[symbolize(event_name)] = { symbolize(handler_name) => block }
        return
      end

      events[symbolize(event_name)].store(symbolize(handler_name), block)
    end

    def unsubscribe(event_name:, handler_name:)
      if event_handlers_count(event_name: symbolize(event_name)) > 1
        events[symbolize(event_name)].delete(symbolize(handler_name))
        return
      end

      events.delete(symbolize(event_name))
    end

    def broadcast(*options, event_name:)
      return broadcast_events(options) if event_name.nil?

      broadcast_event(symbolize(event_name), options)
    end

    private

    attr_reader :events

    def broadcast_event(event_name, options)
      broadcasted_messages = []

      events[event_name].values.each do |proc|
        broadcasted_messages << proc.call(options)
      end

      broadcasted_messages
    end

    def broadcast_events(options)
      broadcasted_messages = []

      broadcasted_messages << events.keys.map do |key|
        broadcast_event(key, options)
      end

      broadcasted_messages.flatten!
    end

    def event_registered?(event_name)
      events.keys.any? { |key| key == event_name }
    end

    def symbolize(value)
      value.to_sym
    end
  end
end
