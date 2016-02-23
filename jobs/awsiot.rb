require 'mqtt'
require 'json'

private_key = './tmp/private.key'
cert  = './tmp/cert.pem'
ca_root  = './tmp/ca-root.pem'

Thread.new do
  File.write(private_key, ENV['ZMEINKA_IOT_PRIVATE_KEY'])
  File.write(cert, ENV['ZMEINKA_IOT_CERT'])
  File.write(ca_root, ENV['ZMEINKA_IOT_CA_ROOT'])

  client = MQTT::Client.new
  client.host = 'data.iot.eu-west-1.amazonaws.com'
  client.port = 8883
  client.ssl = true 

  client.cert_file = cert
  client.key_file  = private_key
  client.ca_file   = ca_root

  client.connect() do |client|
    client.subscribe( 'zmeinkaBattery' )

    client.get do |topic,message|
      begin
        parsed = JSON.parse(message) 
        send_event('humidity',    { value: parsed["hum"] })
        send_event('temperature', { value: parsed["temp"] })
        send_event('voltage',     { value: parsed["mvolt"]/1000 })
      rescue
        # 
      end
    end
  end
end
