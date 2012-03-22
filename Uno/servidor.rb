require 'socket'

load "compartidos.rb"
load "clientes.rb"

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
		@clientes = Clientes.new
		loop do 
			Thread.start(@server.accept) do |connection|
				sendM(connection, "Escribe tu nombre")

				@usuario = getM(connection)
				puts "#{@usuario}, Se ha conectado"
				@clientes.set_clientes(@usuario, connection)
				sendM(connection, "Puedes enviar mensajes a los otros usuarios conectados")
				sendM(connection, "Tambien puedes ejecutar los siguientes comandos: ls,cd,cp con su ruta")
				while line = getM(connection)
					# Guarda la ruta y el nombre de un archivo en el servidor
					if line.split(" ")[0] == "publicar_archivo"
						publicar_archivo(line, connection)

					# Envia la lista de los archivos guardados en el servidor
					elsif line == "obtener_lista"
						obtener_lista(connection)

					# paso de mensajes hacia otros peers
					else
						@clientes.get_clientes.each do | nombre, socket |
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
	
	def publicar_archivo(line, connection)
		begin
			direccion = File.split(line.split(" ")[1])
			ruta = direccion[0]
			archivo = direccion[1]
			@compartidos.set_archivos(archivo, ruta)
			@clientes.get_clientes.each do | nombre, socket |
				socket.puts("El archivo #{archivo} fue publicado, su ruta es #{ruta}")								
			end
			puts("archivo: #{archivo}, ruta: #{ruta}")
		rescue
			connection.puts("Error:")
		end
	end

	def obtener_lista(connection)
		lista = ""
		@compartidos.get_archivos.each do |archivo, ruta|
			lista += "Archivo: #{archivo} se encuentra en: #{ruta}\n"
		end
		if lista == ""
			connection.puts("No existen archivos compartidos")
		else
			connection.puts(lista)
		end
	end
	
end

if ARGV.size != 1
  puts "Modo correcto de uso: ruby #{__FILE__} [puerto]"
else
	server = Server.new(ARGV[0].to_i)
  server.run
end
