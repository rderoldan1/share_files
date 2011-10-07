require 'socket'

server = TCPServer.new(2000)

@client={}

loop do 
	Thread.start(server.accept) do |connection|
		n = connection.gets
		@client [n] = connection	
		@client.each do | name, socket |
			if socket.eql? connection
				puts "#{n} dijo "
			else
				socket.puts(n)
			end
		end		
	end	
end
