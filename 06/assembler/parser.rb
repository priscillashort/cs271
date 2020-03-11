require_relative 'a_parser'
require_relative 'c_parser'
require_relative 'label_parser'
require_relative 'variable_manager'

class Parser

	attr_reader :hack_file_name, :line

  def initialize(hack_file_name)
		@hack_file_name = hack_file_name
		@aparser = AParser.new
		@cparser = CParser.new
		@labelparser = LabelParser.new
	end
	
	def parse(line, variable_manager)
		@line = line
		strip_whitespace
		strip_comments

		if a_instruction?
			strip_commercial_at_and_new_line
			parsed_line = @aparser.parse(@line, variable_manager)
			File.write(@hack_file_name, parsed_line << "\n", mode: "a")
		elsif c_instruction?
			parsed_line = @cparser.parse(@line)
			File.write(@hack_file_name, parsed_line << "\n", mode: "a")
		elsif blank_line? || label?
		else
			raise "Line '#{line}' is not valid asm code"
		end

	end

	def add_label_variables(line, variable_manager)
		@line = line
		strip_whitespace
		strip_comments

		if a_instruction? || c_instruction?
			variable_manager.program_line_counter += 1
		elsif label?
			if !variable_manager.variables.key?(line.to_sym)
				@labelparser.parse(@line, variable_manager)
			end
		elsif blank_line?
		else
			raise "Line '#{line}' is not valid asm code"
		end

	end

	def strip_whitespace
		@line = line.gsub(/\s+/, "")
	end
	
	def strip_comments
		@line = line.gsub(/\/\/.+/, "")
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

	def a_instruction?
		self.line[/^@/] == "@"
	end

	def c_instruction?
		self.line[/^M/] == "M" || self.line[/^D/] == "D" || self.line[/^A/] == "A" || self.line[/^0/] == "0"
	end

end