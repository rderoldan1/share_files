require 'socket'

@client = TCPSocket.new('127.0.0.1','2000')

def send_mess(mess)
	puts mess 
	@client.puts(mess)	
end

def suma(a,b)
	c = a+b
	send_mess(c)
end

def resta(a,b)
	c = a-b
	send_mess(c)
end


Thread.new do
	loop do
	message = gets
	send_mess(message)

	end
end

Thread.new do
	loop do
	mess1 = @client.gets.chomp
	puts mess1
		if( mess1.eql? "suma")
		suma(2,4)	
		elsif( mess1.eql? "resta")
		suma(2,4)	
		end

	end
end

loop do
end
