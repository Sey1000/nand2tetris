# Implements `#to_s` which translates itself into a hack machine language
class AInstruction
  INTCODE = '0'.freeze

  def initialize(address:)
    @address = address
  end

  def to_s
    INTCODE + zero_padded_address
  end

  private

  def zero_padded_address
    binary_address = @address.to_i.to_s(2)
    binary_address.rjust(15, '0')
  end
end
