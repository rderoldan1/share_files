require 'socket'

@server
@client={}
@client_number = 1
@files ={}


if ARGV.size != 1
  puts "Usage: ruby #{__FILE__} [port]"
	exit
else
	@server = TCPServer.new(ARGV[0].to_i)
end


loop do 
	Thread.start(@server.accept) do |connection|

		puts "#{@client_number} connected"
		@client[@client_number] = connection
		connection.puts("You are connected as client#{@client_number}\nNow you can sen messages, for help type `help`")
		@client_number = @client_number + 1
		while line = connection.gets.chomp
			# Publicar un archivo
			if line.split(" ")[0].eql? "public_file_save"
				dir = line.split(" ", 2)
				dir = File.split(dir[1])
				route = dir[0]
				file = dir[1]
				@files[file] = route
				# Decirle a todos los peers que el archivo esta online
				@client.each do | name, socket |
					socket.puts("#{file} ha sido publicado")
				end
			elsif line.eql? "get public list"
				list = ""
				@files.each do |file, route|
					list += "\tfile: #{route}/#{file}\n"
				end
				connection.puts(list)
			else
				# Envio de mensajes entre los peers
				@client.each do | name, socket |
					if socket != connection	
						socket.puts(line)
					end
				end
			end
		end	
	end	
end



