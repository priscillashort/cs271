require_relative 'parser'
require_relative 'variable_manager'

class Assembler

	attr_reader :file_name

	def initialize(file_name)
		@file_name = file_name
		@variable_manager = VariableManager.new
	end

	def translate_program
		File.open(file_name).each do |line|

			puts line

			parser = Parser.new(line, @variable_manager)
			@variable_manager = parser.parse

		end

		puts @variable_manager.variables

	end

end

assembler = Assembler.new('code.txt')
assembler.translate_program
