@a = {}
puts "escriba el comando"
@a = gets.split(' ')

@a.each do |com, line|
	puts "#{com} and #{line}"
end
