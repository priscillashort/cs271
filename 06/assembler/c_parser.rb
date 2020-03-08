require_relative 'variable_manager'

class CParser

	attr_accessor :line, :variable_manager

  def initialize(line, variable_manager)
		@line = line
		@variable_manager = variable_manager
	end
	
	def parse
		parse_c_instruction
		@variable_manager
	end

	def parse_c_instruction

	end

end