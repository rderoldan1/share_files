require 'socket'

load "compartidos.rb"

class Server
	
	@server
	@compartidos 

	def initialize(puerto)
		@server = TCPServer.new(puerto)
		@compartidos = Compartidos.new
		puts "Servidor listo, esperando conexiones"
	end
	
	def sendM(dir, menssage)
		dir.puts(menssage)
	end

	def getM(dir)
		dir.gets.chomp
	end

	def run
		@client={}
		loop do 
			Thread.start(@server.accept) do |connection|
				sendM(connection, "Escribe tu nombre")

				@usuario = getM(connection)
				puts "#{@usuario}, Se ha conectado"
				@client [@usuario] = connection	
				sendM(connection, "Puedes enviar mensajes a los otros usuarios conectados")
				sendM(connection, "Tambien puedes ejecutar los siguientes comandos: ls,cd,cp con su ruta")
				while line = getM(connection)
					# Envia la lista de los archivos guardados en el servidor
					if line == "obtener_lista"
						lista = ""
						@compartidos.get_archivos.each do |archivo, ruta|
							lista += "Archivo: #{archivo} se encuentra en: #{ruta}\n"
						end
						connection.puts(lista)
					# Guarda la ruta y el nombre de un archivo en el servidor
					elsif line.split(" ")[0] == "publicar_archivo"
						begin
							direccion = File.split(line.split(" ")[1])
							ruta = direccion[0]
							archivo = direccion[1]
							@compartidos.set_archivos(archivo, ruta)
							@client.each do | nombre, socket |
								socket.puts("El archivo #{archivo} fue publicado, su ruta es #{ruta}")
								puts("archivo: #{archivo}, ruta: #{ruta}")
						end
						rescue
							connection.puts("Error:")
						end
					# paso de mensajes hacia otros peers
					else
						@client.each do | nombre, socket |
							if !socket.eql? connection	
								socket.puts(line)
							else
								puts("#{nombre} envio #{line}")
							end
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
