a = gets.chomp
temp = a.split(' ')
b = File.split(a)
puts b[0]
puts b[1]

		if (temp[1].eql? "")
					puts "entre1"
		else		
			#puts command[1]
			palabra = temp[1]
			temp2 = (temp[1]).split('/')
			@ruta=''
			archivo=''
			puts temp2
			temp2.each do |path|
				if path.eql? temp2.last
					puts 'igual'
					archivo = path
				else
					puts 'diferente'
					@ruta = '/'+@ruta+'/'+path
					puts @ruta
				end
			end
			puts @ruta
			puts archivo
		end
