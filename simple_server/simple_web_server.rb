require 'socket' 				#Get socketes from stdlib
require 'json'

server = TCPServer.open(2000)	#Socket to listen on port 2000
http_version = "HTTP/1.0"
loop { 							#Servers run forever
	client = server.accept		#Wait for client to connect

	request = client.read_nonblock(256)
	headers,body = request.split("\r\n\r\n",2)
	puts headers
	puts body

	headers_parts = headers.split(" ")
	request_method = headers_parts[0]
	request_path = headers_parts[1]
	request_content_length = headers_parts[-1]

	file = request_path.match(/[a-zA-Z]+\.[a-zA-Z]+/).to_s

	if File.exists?(file)
		lines = File.readlines(file)
		text = lines.join
		if request_method == "GET"

			response_body = text
			content_length = text.length
			client.puts "HTTP/1.0 200 OK\r\nContent-type:text/html\r\nContent-Length:#{content_length}\r\n\r\n"
			client.puts response_body
		elsif request_method == "POST"

			li_str  = ""
			params = JSON.parse(body)
			params["user"].each do |key,value|
				li_str += "<li>#{key.capitalize}: #{value}</li>"
			end
			client.puts "HTTP/1.0 200 OK\r\n#{Time.now.ctime}" \
						"\r\nContent-Length: #{request_content_length}\r\n\r\n"
			client.puts text.gsub("<%= yield %>",li_str)
		else
			client.puts "HTTP/1.0 404 Not Found\r\n\r\n"
			client.puts "404 Error, File could not be found"
		end
	end

	client.puts "Closing the connection. Bye!"
	client.close				#Disconnect from the client
}