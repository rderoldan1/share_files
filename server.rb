require 'socket'

server = TCPServer.new(2000)

@client={}
@current = ""

def write(dir, menssage)
	dir.puts(menssage)
end

def recv(dir)
	menssage = dir.gets.chomp
end

loop do 
	Thread.start(server.accept) do |connection|
		#connection.puts("Nombre")
		write(connection, "Nombre")
		#@n = connection.gets.chomp
		@n = recv(connection)
		puts @n
		m = connection.addr
		puts m
		@client [@n] = connection	
		write(connection, "Escriba un mensaje")
		while line = recv(connection)
			if (line.eql? 'share')
								
				file = File.open("routes.txt","w+")
				file.write("client = #{@n}\n")
				write(connection, "que ruta")
				file.puts(recv(connection)+"\n")
				file.close
			end
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
