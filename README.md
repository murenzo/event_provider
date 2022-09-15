# Event Provider Class

Rails Provider Class (RPC) is a light weight class that can be used to register events and thier respective handlers as subscribers. We decided to use ruby blocks as handlers in order to simplify the code as we no longer need a separate class for the handlers. This implementation was modelled after the observer design pattern.

## Usage

1. To register an event and subscribe a ruby block as handler.

```
EventProvider.subscribe(event_name: :order_created, handler_name: :notify_customer) do |_|
  'Notifying the customer that their order has been created'
end
```

2. To register an event and subscribe multiple ruby block as handlers, the handler_name has to be unique.

```
EventProvider.subscribe(event_name: :order_created, handler_name: :notify_customer) do |_|
  'Notifying the customer that their order has been created'
end

EventProvider.subscribe(event_name: :order_created, handler_name: :notify_admin) do |_|
  'Notifying the customer that their order has been created'
end
```

3. To unsubscribe a ruby block as handler from an event. Due to the nature of blocks, we had to introduce the concept of assigning unique keys to registred handlers. This helps with constant look up when unsubscribing a handler from an event.

```
EventProvider.subscribe(event_name: :order_created, handler_name: :notify_customer) do |_|
  'Notifying the customer that their order has been created'
end

EventProvider.unsubscribe(event_name: :order_created, handler_name: :notify_customer)
end
```

4. To broadcast an event which then allows the respective handlers to respond. Also, an arbitrary number of arguments can be passed as argument which then can be called by all the stored blocks. It returns an array of messages returned from registered handlers.

```
EventProvider.subscribe(event_name: :order_created, handler_name: :notify_customer) do |options|
  "Notifying customer that an order has been placed #{options.join(',')}."
end

result = EventProvider.broadcast('a', 'b', 'c', 'd', event_name: :order_created)
```

5. To broadcast all events which then allows each respective registered handlers to respond. Also, an arbitrary number of arguments can be passed as argument which then can be called by all the stored blocks. It returns an array of messages returned from registered handlers.

```
EventProvider.subscribe(event_name: :order_created, handler_name: :notify_customer) do |options|
  "Notifying customer that an order has been placed #{options.join(',')}."
end

result = EventProvider.broadcast('a', 'b', 'c', 'd', event_name: nil)
```

## Helper Methods
```
EventProvider.registered_events_count # Returns the total number of registered events

EventProvider.event_handlers_count(event_name: 'event_name') # Returns the total number of handlers belonging to an event

EventProvider.clear_events # Clear all registered events
```

## TODO
Improve validation in the program
