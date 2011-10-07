require 'find'


@comand = {}
line = {}

puts "escriba el comando"
line = gets.split(' ')

@comand [line[0]] = line[1]
	@comand.each do |sufix, route|
		if (sufix.eql? "cd")
			cd(route)
		end
		
	end


#emula comando cd
def cd(route)
	Dir.chdir(route)
	puts Dir.pwd
	

end




