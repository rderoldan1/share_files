
	puts Dir.pwd
ARGV.each do |wd|
	puts "trabajando en #{wd}:"
	Dir.chdir(wd)
	puts Dir.pwd

end
