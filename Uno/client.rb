require 'socket'

class Client
	@client

	def initialize(ip,puerto)
		@client = TCPSocket.new(ip,puerto)
	end
	
	def run
		# Hilos para escuchar y enviar mensajes
		hilo1 = Thread.new{thread_get}
		hilo2 = Thread.new{thread_send}
	
		hilo1.join
		hilo2.join
	end
	
	# Hilo de envio de mensajes
	def thread_send
			begin	
			while not STDIN.eof?
				lineOut = STDIN.gets.chomp
				if lineOut == "QUIT" || lineOut == "quit"
					exit
				elsif lineOut == "-help"
					help
				else
					sendM(lineOut)
				end
			end
		end
	end

	# Hilo de recivo de mensajes
	def thread_get

		begin
			while not @client.eof?
				lineIn = getM()
				puts lineIn		
				temp  = lineIn.split(' ')
				case temp[0]
					when "cd"
						cd(temp[1])	
					when "ls"
						ls(temp[1])
					when "cp"
						cp(temp[1])
					when "Crear"
						crear(temp[1])
				end	
			end
		end
	end

	# Envia mensaje por socket
	def sendM(message)
		@client.puts(message)	
	end

	# Recive mensaje del socket
	def getM()
		@client.gets.chomp
	end	

	# Emula comando cd
	def cd (ruta)
		Dir.chdir(ruta)
		direccion = Dir.pwd
		sendM(direccion)
	end

	# Emula el comando ls
	def ls(ruta)
		begin
			direccion = Dir.entries(ruta)
			exp = /^[a-zA-Z|0-9]/
			direccion.each do | file |
				if (exp.match(file))
					sendM(file)
				end
			end
		rescue
			sendM("Error: verifica tu sintaxis")
		end
	end 

	# Emula comando cp
	def cp(ruta)
		begin
			direccion = File.split(ruta)
			ruta = direccion[0]
			archivo = direccion[1]
			Dir.chdir(ruta)
		
			if(File.exists?(archivo))
				ext = File.extname(archivo)
				sendM("Crear #{archivo} ")
				file = File.open(archivo)

				file.each do |line|
					sendM(line)				
				end	

				file.close
				sendM("eof")				
			else
				sendM("Error: el archivo o directorio no existe")
			end
		rescue
			sendM("Error: verifica tu sintaxis")
		end
	end
 
	# Crea un archivo 
	def crear(name)
		begin
			f = File.new(name, "w+")
			puts "Copiando archivo, por favor espere"
			message = ""
			while (message != "eof")
				message = getM()
				if(message != "eof")		
					f.write(message+"\n")
				end
			end
			f.close
			puts "Archivo #{name} fue creado"
		rescue
			sendM("Error: verifica tu sintaxis")
		end
	end
	
	def help
		puts "-----------------Ayuda-----------------"
		
	end
end

if ARGV.size != 2
  puts "Modo correcto de uso: ruby #{__FILE__} [ipServer] [puerto]"
else
	client = Client.new(ARGV[0], ARGV[1].to_i)
  client.run
end
