class Compartidos
	@archivos
	def initialize
		@archivos = {}
	end 

	def get_archivos
		@archivos
	end	

	def set_archivos(archivo, ruta)
		@archivos[archivo] = ruta
	end

end
