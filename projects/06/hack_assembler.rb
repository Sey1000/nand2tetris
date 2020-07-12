#!/usr/bin/env ruby
require_relative './parser'
require_relative './label_handler'

class HackAssembler
  def initialize(input_file_path, output_file_path)
    @input_file_path = input_file_path
    @output_file_path = output_file_path
    @symbol_table = default_symbol_table
  end

  def run
    # First pass --> only read and save symbols to symbol_table
    @symbol_table = LabelHandler.new(@symbol_table, @input_file_path).generate!
    parser = Parser.new(@symbol_table)
    # Second pass --> read and translate line by line
    File.open(@output_file_path, 'w') do |f|
      File.foreach(@input_file_path) do |line|
        next if comment_or_empty_line?(line.strip!)
        next if label_declaration_line?(line)
        parsed_line = parser.parse(line)
        f.write(parsed_line + "\n")
      end
    end
  end

  private

  def comment_or_empty_line?(line)
    return true if line.empty?
    return true if line.start_with?('//')
    false
  end

  def default_symbol_table
    @default_symbol_table ||= (0..15).to_a.map { |ind| ["R#{ind}", ind] }.to_h
      .merge('SCREEN' => 16384, 'KBD' => 24576, 'SP' => 0, 'LCL' => 1, 'ARG' => 2, 'THIS' => 3, 'THAT' => 4)
  end

  def label_declaration_line?(line)
    line.start_with?('(')
  end
end

# Take input asm file
asm_file_path = "#{__dir__}/#{ARGV[0]}"
asm_file = File.open(asm_file_path)

# Handle output directory
filename = File.basename(asm_file_path, '.asm')
output_directory = "#{__dir__}/assembled"
Dir.mkdir(output_directory) unless File.exists?(output_directory)

hack_file_path = "#{output_directory}/#{filename}.hack"

HackAssembler.new(asm_file, hack_file_path).run
