#!/usr/bin/env ruby
require_relative './parser'

class HackAssembler
  def initialize(input_file, output_file_path)
    @input_file = input_file
    @output_file_path = output_file_path
    # TODO: @symbol_table = symbol_table
  end

  def run
    # TODO: First pass --> only read and save symbols to symbol_table
    # Second pass --> read and translate line by line
    File.open(@output_file_path, 'w') do |f|
      @input_file.each do |line|
        next if comment_or_empty_line?(line.strip!)
        parsed_line = Parser.new(line).parse
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
