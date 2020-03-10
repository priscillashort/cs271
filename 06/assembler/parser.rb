require_relative 'a_parser'
require_relative 'c_parser'
require_relative 'label_parser'
require_relative 'variable_manager'

class Parser

	attr_reader :hack_file_name, :asm_file_name, :line

  def initialize(hack_file_name, asm_file_name)
		@hack_file_name = hack_file_name
		@asm_file_name = asm_file_name
	end
	
	def parse(line, variable_manager)
		@line = line
		@line = strip_whitespace
		@line = strip_comments
		aparser = AParser.new
		cparser = CParser.new
		labelparser = LabelParser.new

		if a_instruction?
			strip_commercial_at_and_new_line
			label_line_number = 0
			rom_variable = label_exists_in_file?

			if rom_variable
				label_line_number = get_rom_line_number
			end

			parsed_line = aparser.parse(@line, variable_manager, rom_variable, label_line_number)
			File.write(@hack_file_name, parsed_line << "\n", mode: "a")
			variable_manager.program_line_counter += 1
		elsif c_instruction?
			parsed_line = cparser.parse(@line)
			File.write(@hack_file_name, parsed_line << "\n", mode: "a")
			variable_manager.program_line_counter += 1
		elsif label?
			labelparser.parse(@line, variable_manager)
		elsif blank_line?
		else
			raise "Line '#{line}' is not valid asm code"
		end

	end

	def strip_whitespace(parse_line = line)
		parse_line.gsub(/\s+/, "")
	end
	
	def strip_comments(parse_line = line)
		parse_line.gsub(/\/\/.+/, "")
	end

	def strip_commercial_at_and_new_line
		@line = line.gsub(/\@+/, "").gsub(/\n+/, "")
	end

	def blank_line?
		self.line == ""
	end
	
	def label?
		self.line[/^\(/] == "(" && self.line[/\)$/] == ")"
	end

	def a_instruction?(parse_line = line)
		parse_line[/^@/] == "@"
	end

	def c_instruction?(parse_line = line)
		parse_line[/^M/] == "M" || parse_line[/^D/] == "D" || parse_line[/^A/] == "A" || parse_line[/^0/] == "0"
	end

	def label_exists_in_file?
		File.read(asm_file_name).include?("(#{line})")
	end

	def get_rom_line_number
		rom_line_number = 0

		File.open(asm_file_name).each do |parse_line|
			parse_line = strip_whitespace(parse_line)
			parse_line = strip_comments(parse_line)

			if a_instruction?(parse_line) || c_instruction?(parse_line)
				rom_line_number += 1
			end

			if parse_line == "(#{line})"
				break
			end
		end

		rom_line_number
	end

end