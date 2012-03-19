require 'socket'

@server
@client={}
@archivos

if ARGV.size != 1
  puts "Usage: ruby #{__FILE__} [port]"
	exit
else
	@server = TCPServer.new(ARGV[0].to_i)
end



loop do 
	Thread.start(@server.accept) do |connection|

		connection.puts("please, write your name")

		@n = connection.gets.chomp
		puts "#{@n} connected"
		@client [@n] = connection	
		connection.puts("you can sen messages, or type (ls,cp) plus the route")
		while line = connection.gets.chomp
			@client.each do | name, socket |
				if socket != connection	
					socket.puts(line)
				end
			end
		end	
	end	
end



