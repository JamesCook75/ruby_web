require 'socket'
require 'json'

server = TCPServer.open(3000)
file = "/index.html"

loop {
  puts "awaiting connections..."
  client = server.accept
  puts "Connection made"
  log = ""

  while line = client.gets
    log += line
    break if log =~ /\r\n\r\n$/
  end

  puts "Request received: #{log}"
  packet = log.split(" ")

  command = packet[0]
  path = packet[1].to_s
  content = packet.last

  if command == 'GET'
    if File.exist?(path)
      f = File.open(path)
      response = f.read
      f.close
      client.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{response.bytesize}\r\n" +
                   "Connection: close\r\n\r\n"
      client.print response
      client.close
    else
      response = "File not found\r\n\r\n"
      client.print "HTTP/1.1 404 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{response.bytesize}\r\n" +
                   "Connection: close\r\n\r\n"
      client.print response

      client.close
    end
  elsif command == 'POST'
    params = JSON.parse(content)
    update = "<li> Name:  #{params['viking']['user']} </li>\n      <li> Email:  #{params['viking']['email']} </li>"
    f = File.open(path)
    content = f.read
    f.close
    new_content = content.gsub("<%= yield %>", update)
    client.print "HTTP/1.1 200 OK\r\n" +
                 "Content-Type: html\r\n" +
                 "Content-Length: #{new_content.bytesize}\r\n" +
                 "Connection: close\r\n\r\n"
    client.print new_content
    client.close

  end

}
