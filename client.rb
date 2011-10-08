require 'socket'

client = TCPSocket.new('127.0.0.1','2000')
@n = 0

#emula comando cd
def cd (route)
	Dir.chdir(route)
	puts Dir.pwd
end

#emula el comando ls
def ls(route)
	#entries aplica el ls al directorio
	puts Dir.entries(route)
end


messageIn = {}
command = {}


Thread.new do 
	loop do
		messageOut = gets
		client.puts(messageOut)
	end

end


Thread.new do
	loop do
		messageIn = client.gets.chomp
		puts messageIn		
		temp  = messageIn.split(' ')
#		puts messageIn
		command [temp[0]] = temp[1]
		command.each do |sufix, route|
			if (sufix.eql? "cd")
				cd(route)	
			elsif (sufix.eql? "ls")
				ls(route)
			end
			if (sufix.eql? 'quit')
				@n = 1
			end
		end
		command.delete(0,1)
		puts command
		
	end

end

while (@n.eql? 0 )

end


