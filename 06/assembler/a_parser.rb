require_relative 'variable_manager'

class AParser

	attr_accessor :line, :variable_manager

  def initialize(line, variable_manager)
		@line = line
		@variable_manager = variable_manager
	end
	
	def parse
		parse_a_instruction
		@variable_manager
	end

	def parse_a_instruction
		strip_commercial_at_and_new_line

		if register_address?
			puts "0" + convert_to_binary(self.line)
		else
			if !@variable_manager.variables.key?(self.line.to_sym)
				@variable_manager.variables[self.line.to_sym] = @variable_manager.variable_counter
				@variable_manager.variable_counter += 1
			end
			puts "0" + convert_to_binary(@variable_manager.variables[self.line.to_sym])
		end
	end

	def strip_commercial_at_and_new_line
		@line = line.gsub(/\@+/, "").gsub(/\n+/, "")
	end

	def register_address?
		self.line.gsub(/\@+/, "")[/^[0-9]+$/] != nil
	end

	def convert_to_binary(line_string)
		pad_leading_zeros(binary_string(line_string.to_i))
	end

	def binary_string(decimal_num)
		binary = (decimal_num % 2).to_s 
		if decimal_num == 0
			return binary
		elsif decimal_num == 1
			return 1.to_s
		else 
			return binary = binary_string(decimal_num / 2).to_s + binary
		end
		return binary.to_i
	end

	def pad_leading_zeros(binary_string)
		format('%015d', binary_string)
	end

end