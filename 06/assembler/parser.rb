require_relative 'a_parser'
require_relative 'c_parser'
require_relative 'label_parser'
require_relative 'variable_manager'

class Parser

	attr_reader :line, :variable_manager

  def initialize(line, variable_manager)
		@line = line
		@variable_manager = variable_manager
	end
	
	def parse
		strip_whitespace
		strip_comments

		if a_instruction?
			aparser = AParser.new(@line, @variable_manager)
			@variable_manager = aparser.parse
			@variable_manager.program_line_counter += 1
		elsif c_instruction?
			cparser = CParser.new(@line)
			cparser.parse
			@variable_manager.program_line_counter += 1
		elsif label?
			labelparser = LabelParser.new(@line, @variable_manager)
			@variable_manager = labelparser.parse
		elsif blank_line?
		else
			raise "NOT VALID CODE"
		end

		@variable_manager
	end

	def strip_whitespace
		@line = line.gsub(/\s+/, "")
	end
	
	def strip_comments
		@line = line.gsub(/\/\/.+/, "")
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