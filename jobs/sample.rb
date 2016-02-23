current_humidity = 0
current_temperature = 10
current_voltage = 48

SCHEDULER.every '2s' do
  last_humidity = current_humidity
  last_temperature = current_temperature
  last_voltage = current_voltage

  send_event('humidity',    { current: current_humidity,    last: last_humidity })
  send_event('temperature', { current: current_temperature, last: last_temperature })
  send_event('voltage',     { current: current_voltage,     last: last_voltage })
  #send_event('synergy',   { value: rand(100) })
end
