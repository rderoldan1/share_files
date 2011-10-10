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
			messageIn = recv_mess()
			puts messageIn		
			temp  = messageIn.split(' ')
			command [0] = temp[0]
			command [1] = temp[1]		
				if (temp[0].eql? "cd")
					cd(temp[1])	
				elsif (temp[0].eql? "ls")
					ls(temp[1])
				elsif (temp[0].eql? 'quit')
					@n = 1
				end
		
		end
	end
end


thread1 = Thread.new{thread_recv}
thread2 = Thread.new{thread_send}

thread1.join
thread2.join




