# Takes input line, decomposes into either A or C instruction hash

require_relative './a_instruction'
require_relative './c_instruction'

class Parser
  A_INSTRUCTION_PREFIX = '@'.freeze
  C_INSTRUCTION_REGEX = /(?<dest>[A-Z]*=)?(?<comp>[\w\-\+\!\&\|]+)(?<jump>;[A-Z]*)?/.freeze

  def initialize(line)
    @line = line
    @a_instruction = line.start_with?(A_INSTRUCTION_PREFIX)
  end

  def parse
    parsed_instruction = @a_instruction ? parse_a_instruction : parse_c_instruction
    parsed_instruction.to_s
  end

  private

  def parse_a_instruction
    AInstruction.new(address: @line[1..])
  end

  def parse_c_instruction
    match_data = @line.match(C_INSTRUCTION_REGEX)
    # Strip trailing '='
    dest = match_data[:dest]&.[](0..-2)
    # Strip leading ';'
    jump = match_data[:jump]&.[](1..)

    CInstruction.new(dest: dest, comp: match_data[:comp], jump: jump)
  end
end
