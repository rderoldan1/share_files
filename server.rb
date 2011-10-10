require 'socket'

server = TCPServer.new(2000)

@client={}

loop do 
	Thread.start(server.accept) do |connection|
		connection.puts("Nombre")
		n = connection.gets.chomp
		puts n
		m = connection.addr
		puts m
		@client [n] = connection	
		connection.puts("Escriba un mensaje")
		while line = connection.gets
			
			@client.each do | name, socket |
				if socket.eql? connection
				else	
					socket.puts(line)
					puts("#{name}")
				end
			end
		end
		
	end	
end
