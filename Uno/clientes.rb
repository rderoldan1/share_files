class Clientes
	@clientes
	def initialize
		@clientes = {}
	end 

	def get_clientes
		@clientes
	end	

	def set_clientes(cliente, puerto)
		@clientes[cliente] = puerto
	end

end
