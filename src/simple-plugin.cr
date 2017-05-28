require "./mpv"
require "./mpv/plugin"

# Here is the beginning of the MPV plugin!

# The MPV handler
MPVHandler = MPV.get_plugin_handler

puts "Hello world from Crystal plugin '#{MPVHandler.client_name}'"

loop do
  event = MPVHandler.wait_event
  puts "Crystal plugin: Got event: #{event.id}"

  break if event.id == LibMPV::EventType::SHUTDOWN
end

puts "Crystal cplugin got a Shutdown event, bye bye!"
