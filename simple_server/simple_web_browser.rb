require 'socket'
require 'json'

host = "localhost"						#The web server
port = 2000								#Default HTTP port
loop {
	puts "Would you like to make a GET or POST request?"
	input = gets.chomp.upcase

	if input == "GET"
		path = "/index.html"			#The file we want
		#This is the HTTP request we send to fetch a file
		request = "GET #{path} HTTP/1.0\r\n\r\n"
	elsif input == "POST"
		puts "Enter your name: "
		name = gets.chomp
		puts "Enter your email: "
		email = gets.chomp
		params = {:user => {:name => name,:email => email} }
		body = params.to_json
		request = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{body.length}\r\n\r\n#{body}"
	elsif input == "EXIT"
		exit
	end
	socket = TCPSocket.open(host,port)	#Connect to the server
	socket.print(request)				#Send request
	response = socket.read				#Read complete response
	#Split response at first blank line into headers and body
	headers,body = response.split("\r\n\r\n",2)
	puts headers
	puts body							#And display it
	}