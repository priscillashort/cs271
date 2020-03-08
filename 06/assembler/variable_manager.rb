class VariableManager

	attr_accessor :variables, :variable_counter, :program_line_counter

  def initialize
		@variables = {}
		@variable_counter = 16
		@program_line_counter = 0
	end

end