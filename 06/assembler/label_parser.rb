require_relative 'variable_manager'

class LabelParser

	attr_accessor :line, :variable_manager

	def parse(line, variable_manager)
		@line = line
		parse_label(variable_manager)
	end

	def parse_label(variable_manager)
		variable_manager.rom_variables[label.to_sym] = variable_manager.program_line_counter.to_s
	end

	def label
		@line = line.gsub(/\(+/, "")
		@line = line.gsub(/\)+/, "")
		@line = line.gsub(/\n+/, "")
	end

end