require 'socket'

@client
@out = 0
@actual = File.expand_path(File.dirname(File.dirname(__FILE__)))

if ARGV.size != 2
  puts "Usage: ruby #{__FILE__} [host] [port]"
	exit
else
	@client = TCPSocket.new(ARGV[0], ARGV[1].to_i)
end

def search(route)
	begin
		dir = Dir.entries(route)
		exp = /^[a-zA-Z|0-9]/
		dir.each do | file |
			if (exp.match(file))
				@client.puts(file)
			end
		end
	rescue 
		@client.puts("Error")
	end
end 

# Publicar un archivo para que otros peers lo puedan ver
def publish(file)
	begin
		dir = File.split(file)
		Dir.chdir(dir[0])
		if(File.exists?(dir[1]))
			Dir.chdir(@actual)
			@client.puts("public_file_save #{file}")
		else
			puts("error el archivo no existe")
		end	
	rescue
		puts "Error"
	end
end

# Imprime una lista de los archivos publicos en el servidor
def get_public_list(out)
	@client.puts(out)
end

def copy(route)
	dir = File.split(route)
	Dir.chdir(dir[0])
	if(File.exists?(dir[1]))
		@client.puts("Preparando copiado")
		ext = File.extname(dir[1])
		@client.puts("Copying #{dir[1]}")
		file = File.open(dir[1])
		file.each do |line|
			@client.puts(line)			
		end	
		file.close
		@client.puts("eof")		
		@client.puts("Archivo copiado con exito")
	else
		@client.puts("error el archivo no existe")
	end
	
end

# Crea el archivo entrante
def copying(name)
	begin
		Dir.chdir(@actual)
		f = File.new(name, "w+")
		message = ""
		while (message != "eof")
			message = @client.gets.chomp
			if(message != "eof")		
				f.write(message+"\n")
			end
		end
		f.close
	rescue
		@client.puts("Error")
	end
end

# Hilo para enviar los mensajes
def thread_send
	begin	
		while not STDIN.eof?
			out = STDIN.gets.chomp
			if out.eql? "help"
				help
			elsif out.eql? "quit"
				exit
			elsif out.split(" ")[0].eql? "public"
				out = out.split(" ", 2)
				publish(out[1])
			elsif out.eql? "get public list"
				get_public_list(out)
			else
				@client.puts(out)
			end
		end
	end
end

# Hilo para recivir los mensajes
def thread_read
	begin
		while not @client.eof?
			messageIn = @client.gets.chomp
			puts messageIn		
			temp  = messageIn.split(' ')
				if (temp[0].eql? "copy")					
					copy(temp[1])
				elsif (temp[0].eql? "Copying")
					copying(temp[1])
				end		
		end
	end
end


def help
	puts "Ayuda"
	puts "copy: copy copia un archivo que se encuentre en otro peer"
	puts "\tcopy /home/user/algo.txt"
	puts "public: publica un archivo para que los demas peers lo puedan ver"
	puts "\tpublic /home/user/algo.txt"
	puts "get public list: obtine la lista de los archivos y su respectiva ubicacion "

end


read = Thread.new{thread_read}
send = Thread.new{thread_send}

read.join
send.join




