require 'find'
 
# muestra la ruta ./
# que es el directorio de Ruby
puts ("que directorio quiere buscar")
a = gets 
puts a
Find.find( '/home/ruben/Descargas') do |f|
    type = case
    # si la ruta es un fichero -> F
        when File.file?(f) then "F"
        # si la ruta es un directorio -> D
        when File.directory?(f) then "D"
        # si no sabemos lo que es -> ?
        else "?"
    end
  # formatea el resultado
  puts "#{type}: #{f}"
end
