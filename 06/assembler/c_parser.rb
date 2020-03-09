require_relative 'variable_manager'

class CParser

	attr_accessor :line, :jump_bits, :ac_bits, :dest_bits

  def initialize(line)
		@line = line
		@dest_bits = {
			"" => "000",
			"M" => "001",
			"D" => "010",
			"MD" => "011",
			"A" => "100",
			"AM" => "101",
			"AD" => "110",
			"AMD" => "111"
		}
		@ac_bits = {
			"" => "0000000",
			"0" => "0101010",
			"1" => "0111111",
			"-1" => "0111010",
			"D" => "0001100",
			"A" => "0110000",
			"!D" => "0001101",
			"!A" => "0110011",
			"-D" => "0001111",
			"-A" => "0110011",
			"D+1" => "0011111",
			"A+1" => "0110111",
			"D-1" => "0001110",
			"A-1" => "0110010",
			"D+A" => "0000010",
			"D-A" => "0010011",
			"A-D" => "0000111",
			"D&A" => "0000000",
			"D|A" => "0010101",

			"M" => "1110000",
			"!M" => "1110001",
			"M+1" => "1110111",
			"M-1" => "1110010",
			"D+M" => "1000010",
			"D-M" => "1010011",
			"M-D" => "1000111",
			"D&M" => "1000000",
			"D|M" => "1010101",
		}
		@jump_bits = {
			"" => "000",
			"JGT" => "001",
			"JEQ" => "010",
			"JGE" => "011",
			"JLT" => "100",
			"JNE" => "101",
			"JLE" => "110",
			"JMP" => "111"
		}
	end
	
	def parse
		parse_c_instruction
	end

	def parse_c_instruction
		split_on_eq = line.split('=')

		if split_on_eq.size > 2 || split_on_eq.size == 0
			raise "Invalid C instruction"
		end

		before_eq = split_on_eq.size == 1 ? "" : split_on_eq[0]
		after_eq = split_on_eq.size == 1 ? split_on_eq[0] : split_on_eq[1]
		split_on_semi = after_eq.split(';')

		if split_on_semi.size > 2 || split_on_semi.size == 0
			raise "Invalid C instruction"
		end

		before_semi = split_on_semi[0]
		after_semi = split_on_semi.size == 1 ? "" : split_on_semi[1]

		result = ""

		begin
			result << ac_bits[before_semi]
			result << dest_bits[before_eq]
			result << jump_bits[after_semi]
		rescue
			raise "Invalid C instruction"
		end

		puts "111" << result
	end

end