# Takes input line, decomposes into either A or C instruction hash

require_relative './a_instruction'
require_relative './c_instruction'

class Parser
  A_INSTRUCTION_PREFIX = '@'.freeze
  C_INSTRUCTION_REGEX = /^(?<dest>[A-Z]*=)?(?<comp>[\w\-\+\!\&\|]+)(?<jump>;[A-Z]*)?/.freeze

  def initialize(symbol_table)
    @memory_location = 16
    @symbol_table = symbol_table
  end

  def parse(line)
    @line = line
    a_instruction = @line.start_with?(A_INSTRUCTION_PREFIX)
    parsed_instruction = a_instruction ? parse_a_instruction : parse_c_instruction
    parsed_instruction.to_s
  end

  private

  def parse_a_instruction
    address = @line[1..]
    # handle variable if address starts with non-digit character
    address_number = address.start_with?(/\d/) ? address : handle_variable(address)

    AInstruction.new(address: address_number)
  end

  def parse_c_instruction
    match_data = @line.match(C_INSTRUCTION_REGEX)
    # Strip trailing '='
    dest = match_data[:dest]&.[](0..-2)
    # Strip leading ';'
    jump = match_data[:jump]&.[](1..)

    CInstruction.new(dest: dest, comp: match_data[:comp], jump: jump)
  end

  def handle_variable(address)
    @symbol_table.fetch(address) do |add|
      @symbol_table[add] = @memory_location
      @memory_location += 1
    end

    @symbol_table[address]
  end
end
