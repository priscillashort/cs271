require_relative 'variable_manager'

class AParser

	attr_accessor :line
	attr_reader :rom_variable, :label_line_number

	def parse(line, variable_manager, rom_variable, label_line_number)
		@line = line
		@rom_variable = rom_variable
		@label_line_number = label_line_number
		parse_a_instruction(variable_manager)
	end

	def parse_a_instruction(variable_manager)
		hack_line = ""

		if numeric_register_address?
			hack_line = "0" + convert_to_binary(line)
		else

			if !rom_variable && !variable_manager.ram_variables.key?(line.to_sym)
				variable_manager.ram_variables[line.to_sym] = variable_manager.ram_variable_counter
				variable_manager.ram_variable_counter += 1
			elsif rom_variable
				variable_manager.rom_variables[line.to_sym] = label_line_number
			end

			if rom_variable
				hack_line = "0" + convert_to_binary(variable_manager.rom_variables[line.to_sym])
			else
				hack_line = "0" + convert_to_binary(variable_manager.ram_variables[line.to_sym])
			end
		end

		hack_line
	end

	def numeric_register_address?
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