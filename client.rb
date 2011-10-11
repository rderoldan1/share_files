require 'socket'

@client = TCPSocket.new('127.0.0.1','2000')

@n = 0

#emula comando cd
def cd (route)
	Dir.chdir(route)
	#puts Dir.pwd
	a = Dir.pwd
	send_mess(a)
end

#emula el comando ls
def ls(route)
	a = Dir.entries(route)
	exp = /^[a-zA-Z|0-9]/
	a.each do | file |
		if (exp.match(file))
			puts file
			send_mess(file)
		end
	end
end 

#emula comando cp
def cp(route)
	dir = File.split(route)
	puts dir[0]
	Dir.chdir(dir[0])
	if(File.exists?(dir[1]))
		puts "exist"
		puts Dir.pwd
		puts dir[1]
		ext = File.extname(dir[1])
		send_mess("create #{dir[1]} ")
#		file = File.open(dir[1])
#		send_mess(file)
#		file.close
		
	else
		send_mess("error el archivo no existe")
	end
	
end

def create(name)
	f = File.new(name, "a+")
	f.close
end

#envia mensaje por socket
def send_mess(mess)
	@client.puts(mess)	
end

#revive mensaje del socket
def recv_mess()
	menssage = @client.gets.chomp
	return (menssage)
end

def thread_send
	begin	
		#hilo de envio de mensajes
		while (@n.eql? 0)
			messageOut = gets
			send_mess(messageOut)
		end
	end
end




def thread_recv
	messageIn = {}
	command = {}

	begin
	#hilo de recivo de mensajes
		while (@n.eql? 0)
			command = []			
			messageIn = recv_mess()
			puts messageIn		
			temp  = messageIn.split(' ')
				if (temp[0].eql? "cd")
					cd(temp[1])	
				elsif (temp[0].eql? "ls")
					ls(temp[1])
				elsif (temp[0].eql? 'quit')
					@n = 1
				elsif (temp[0].eql? "cp")
					puts temp[1]					
					cp(temp[1])
					
				elsif (temp[0].eql? "create")
					create(temp[1])
				end
		
		end
	end
end


thread1 = Thread.new{thread_recv}
thread2 = Thread.new{thread_send}

thread1.join
thread2.join




