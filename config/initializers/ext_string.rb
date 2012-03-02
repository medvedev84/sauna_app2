class String

	def nonnegative_integer?
		Integer(self) >= 0
	rescue ArgumentError
		return false
	end

end