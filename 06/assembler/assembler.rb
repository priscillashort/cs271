require_relative 'parser'
require_relative 'variable_manager'

require 'fileutils'

class Assembler

	attr_reader :asm_file_name, :hack_file_name, :variable_manager

	def initialize(asm_file_name)
		@asm_file_name = asm_file_name
		@hack_file_name = create_hack_file_name
		@variable_manager = VariableManager.new
	end

	def translate_program
		create_hack_file
		parser = Parser.new(@hack_file_name)

		File.open(asm_file_name).each do |line|
			parser.add_label_variables(line, variable_manager)
		end

		File.open(asm_file_name).each do |line|
			parser.parse(line, variable_manager)
		end

	end

	def create_hack_file_name
		if asm_file_name[/\.asm$/] != ".asm"
			raise "This is not an .asm file"
		end

		return asm_file_name.gsub(/\.asm$/, ".hack")
	end

	def create_hack_file
		if File.exists?(@hack_file_name)
			FileUtils.rm(@hack_file_name)
		end

		FileUtils.touch(@hack_file_name)
	end

end

assembler = Assembler.new(ARGV[0])
assembler.translate_program
