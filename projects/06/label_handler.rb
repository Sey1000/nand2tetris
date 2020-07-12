class LabelHandler
  LABEL_PATTERN = /^\((?<label>\S+)\)/.freeze

  def initialize(symbol_table, input_file_path)
    @symbol_table = symbol_table
    @input_file_path = input_file_path
    @line_count = -1
  end

  def generate!
    File.foreach(@input_file_path) do |line|
      next if comment_or_empty_line?(line.strip!)
      if label_declaration_line?(line)
        add_label_to_symbol_table(line)
      else
        @line_count += 1
      end
    end

    @symbol_table
  end

  private

  def label_declaration_line?(line)
    line.start_with?('(')
  end

  def comment_or_empty_line?(line)
    return true if line.empty?
    return true if line.start_with?('//')
    false
  end

  def add_label_to_symbol_table(line)
    label = line.match(LABEL_PATTERN)[:label]
    @symbol_table[label] = @line_count + 1
  end
end
