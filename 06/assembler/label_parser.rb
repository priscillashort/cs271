require_relative 'variable_manager'

class LabelParser

	attr_accessor :line, :variable_manager

  def initialize(line, variable_manager)
		@line = line
		@variable_manager = variable_manager
	end
	
	def parse
		parse_label
		@variable_manager
	end

	def parse_label
		@variable_manager.variables[label.to_sym] = @variable_manager.program_line_counter.to_s
	end

	def label
		@line = line.gsub(/\(+/, "")
		@line = line.gsub(/\)+/, "")
		@line = line.gsub(/\n+/, "")
	end

end