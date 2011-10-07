require 'soket'

client = TCPSocket.new('127.0.0.1','2000')
@n = 0
Thread.new do 
	loop do
		messageOut = gets
		client.puts(messageOut)
	end

end


Thread.new do
	loop do
		menssageIn = client.gets.chomp
		if (menssageIn.eql? 'quit')
			@n = 1
		end
		
	end

end

while (@n.eql 0 )

end


