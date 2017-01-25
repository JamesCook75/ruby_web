require 'socket'
require 'json'

host = 'localhost'     # The web server
port = 3000                           # Default HTTP port
                # The file we want

puts "Would you like to 1: View or 2: Post"
answer = gets.chomp

case answer.to_i
when 1
  # This is the HTTP request we send to fetch a file
  path = "index.html"
  request = "GET #{path} HTTP/1.0\r\n\r\n"

  socket = TCPSocket.open(host,port)  # Connect to server
  socket.print(request)               # Send request
  response = socket.read              # Read complete response
  # Split response at first blank line into headers and body
  headers,body = response.split("\r\n\r\n", 2)
  print body                          # And display it
when 2
  puts "Please enter your name: "
  user_name = gets.chomp
  puts "Please enter you email: "
  user_email = gets.chomp
  hash = {:viking => {:user => user_name, :email => user_email}}
  message = hash.to_json

  path = "thanks.html"
  request = "POST #{path} HTTP/1.0
            From: someone@somewhere.com
            User-Agent: ConsoleBrowser
            Content-Type: application/JSON
            Content-Length: #{message.size}
            #{message}\r\n\r\n"

  socket = TCPSocket.open(host,port)  # Connect to server
  socket.print(request)               # Send request
  response = socket.read              # Read complete response
  # Split response at first blank line into headers and body
  headers,body = response.split("\r\n\r\n", 2)
  print body
end
