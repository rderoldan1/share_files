require 'socket'

class Server
	
	@server

	def initialize(puerto)
		@server = TCPServer.new(puerto)
		puts "Servidor listo, esperando conexiones"
	end
	
	def sendM(dir, menssage)
		dir.puts(menssage)
	end

	def getM(dir)
		menssage = dir.gets.chomp
	end

	def run
		@client={}
		@current = ""
		loop do 
			Thread.start(@server.accept) do |connection|
				sendM(connection, "Escribe tu nombre")
				#@n = connection.gets.chomp
				@n = getM(connection)
				puts "#{@n}, Se ha conectado"
				@client [@n] = connection	
				sendM(connection, "Puedes enviar mensajes a los otros usuarios conectados")
				sendM(connection, "Tambien puedes ejecutar los siguientes comandos: ls,cd,cp con su ruta")
				while line = getM(connection)
					@client.each do | name, socket |
						if !socket.eql? connection	
							socket.puts(line)
						else
							puts("#{name} envio #{line}")
						end
					end
				end
		      
			end	
		end
	end

end

if ARGV.size != 1
  puts "Modo correcto de uso: ruby #{__FILE__} [puerto]"
else
	server = Server.new(ARGV[0].to_i)
  server.run
end
