require 'socket'

class Client
	@conexion
	@ruta_base

	def initialize(ip,puerto)
		@conexion = TCPSocket.new(ip,puerto)
		@ruta_base = ""+File.expand_path(File.dirname(File.dirname(__FILE__)))
	end
	
	def run
		# Hilos para escuchar y enviar mensajes
		hilo1 = Thread.new{leer}
		hilo2 = Thread.new{escribir}	

		hilo1.join
		hilo2.join
	end
	
	# Hilo de envio de mensajes
	def escribir
			begin	
			while not STDIN.eof?
				lineOut = STDIN.gets.chomp
				if lineOut == "QUIT" || lineOut == "quit"
					exit
				elsif lineOut.split(" ")[0] == "compartir"
					compartir(lineOut.split(" ",2)[1])
				elsif lineOut == "lista compartidos" || lineOut == "lista c"
					obtener_lista
				elsif lineOut == "-help"
					ayuda
				else
					sendM(lineOut)
				end
			end
		end
	end

	# Hilo de recivo de mensajes
	def leer
		begin
			while not @conexion.eof?
				lineIn = getM()
				temp  = lineIn.split(' ')
				case temp[0]
					when "cd"
						cd(temp[1])	
					when "ls"
						examinar(temp[1])
					when "cp"
						copiar(temp[1])
					when "Crear"
						crear(temp[1])
					else 
						puts lineIn	
				end	
			end
		end
	end

	# Envia mensaje por socket
	def sendM(message)
		@conexion.puts(message)	
	end

	# Recive mensaje del socket
	def getM()
		@conexion.gets.chomp
	end	

	# Emula comando cd
	def cd (ruta)
		Dir.chdir(ruta)
		direccion = Dir.pwd
		sendM(direccion)
	end

	# Emula el comando ls
	def examinar(ruta)
		begin
			direccion = Dir.entries(ruta)
			inicio = /^[\w|\d]/
			direccion.each do | file |
				if (inicio.match(file))
					sendM(file)
				end
			end
		rescue
			sendM("Error: verifica tu sintaxis")
		end
	end 

	# Emula comando cp
	def copiar(ruta)
		begin
			direccion = File.split(ruta)
			ruta = direccion[0]
			archivo = direccion[1]
			# Establecer el path del archivo a copiar
			Dir.chdir(ruta)
			
			# Preguntar si el archivo existe dentro del path para luego enviarlo
			if(File.exists?(archivo))
				ext = File.extname(archivo)
				sendM("Crear #{archivo}")
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
			# Establecer el path al mismo de cliente.rb para que el archivo que se va a copiar quede en el mismo directorio
			Dir.chdir(@ruta_base)
			f = File.new(name, "w+")
			puts "\tCopiando archivo, por favor espere"
			message = ""
			while (message != "eof")
				message = getM()
				if(message != "eof")		
					f.write(message+"\n")
				end
			end
			f.close
			puts "\tArchivo #{name} fue creado"
		rescue
			sendM("Error: verifica tu sintaxis")
		end
	end

	# Metodo para compartir la ruta de un archivo con otros peers
	def compartir(link)
		sendM("publicar_archivo #{link}")
	end

	# Obtiene la lista de todos los archivos que han compartido lo peers
	def obtener_lista
		sendM("obtener_lista")
	end

	def ayuda
		puts "-----------------Ayuda-----------------"
		puts "para examinar directorios:"
		puts "\tejemplo examinar /home/user/Escritorio"
		puts "para copiar archivos:"
		puts "\tejemplo copiar /home/user/Escritorio/readme.txt"
		puts "para cambiar de directorio:"
		puts "\tejemplo cd /home/user/Escritorio"
		puts "para compartir un archivo:"
		puts "\tejemplo compartir /home/user/Escritorioreadme.txt"
		puts "para ver la lista de archivos compartidos:"
		puts "\tejemplo lista compartidos o lista c"
		puts "para terminar el programa:"
		puts "\tquit"
	end
end

if ARGV.size != 2
  puts "Modo correcto de uso: ruby #{__FILE__} [ipServer] [puerto]"
else
	client = Client.new(ARGV[0], ARGV[1].to_i)
  client.run
end

