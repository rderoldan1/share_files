require 'find'


@comand = {}
line = {}


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

puts "escriba el comando"
#aplica metodo split al comando ingresado
line = gets.split(' ')
puts Dir.pwd

@comand [line[0]] = line[1]
	@comand.each do |sufix, route|
		if (sufix.eql? "cd")
			cd(route)
#		end	
		elsif (sufix.eql? "ls")
			ls(route)
		end
		
	end


