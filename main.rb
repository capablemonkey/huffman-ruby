require 'pp'
# require 'profile' # to determine performance bottlenecks

INPUT_FILE_NAME = 'sample.txt'
OUTPUT_FILE_NAME = 'output.txt'

class BinaryTreeNode
  attr_accessor :byte, :freq, :parent_node, :left_node, :right_node
  def initialize(byte=nil, freq=nil, parent_node=nil, left_node=nil, right_node=nil)
    @byte = byte
    @freq = freq
    @left_node = left_node
    @right_node = right_node
  end

  def leaf?
    @left_node.nil? && @right_node.nil?
  end
end

class BinaryTree
  attr_accessor :root_node

  def initialize(root_node)
    @root_node = root_node
  end

  def traverse_preorder(proc, current_node=nil, path=nil)
    current_node = if current_node then current_node else @root_node end

    # path is a sequence of left (0) and right (1) moves from the root node to arrive at the current node
    path = if path then path else [] end

    if current_node.leaf? and current_node.byte
      return proc.call(current_node, path)
    end

    if current_node.left_node
      self.traverse_preorder(proc, current_node.left_node, path + [0])
    end

    if current_node.right_node
      self.traverse_preorder(proc, current_node.right_node, path + [1])
    end
  end
end

class HuffmanEncoder
  def initialize(input_file)
    raise 'Missing input file' if input_file.nil?

    @input_file = input_file
    @input_file.rewind
    frequencies = get_frequencies(input_file)
    binary_tree = build_tree_from_frequencies(frequencies)
    @encoding = build_byte_to_code_table(binary_tree)

    # print frequency, character, and encoding:
    # binary_tree.traverse_preorder(lambda { |node, path| pp node.freq.to_s << ':'<< node.byte << " => " << path.join()} )
    # pp @encoding
  end

  def output_as_string
    @input_file.rewind
    @input_file.each_byte.map { |k| @encoding[k].to_s }.join
  end

  def output_to_file(output_file)
    output_file.rewind
    bit_string = output_as_string

    output_file.binmode
    output_file.write [bit_string].pack('B*')
  end

  def decode(bit_string)
    @decoding = @encoding.invert

    buffer = ''
    output = ''
    bit_string.each_char do |bit|
      buffer << bit.to_s

      if @decoding.include?(buffer)
        output << @decoding[buffer]
        buffer = ''
      end
    end

    output
  end

  private

  def build_tree_from_frequencies(frequencies)
    # Turn each (byte, frequency) tuple into a Node and add to priority queue:
    priority_q = []

    frequencies.each do | byte, freq |
      priority_q.push BinaryTreeNode.new(byte, freq)
    end

    while priority_q.size > 1
      first = priority_q.shift
      second = priority_q.shift
      combined_frequency = first.freq + second.freq
      internal_node = BinaryTreeNode.new(nil, combined_frequency, nil, first, second)
      priority_q.push(internal_node)
      priority_q.sort_by! { |node| node.freq }
    end

    # when there's only one node left, that's the root node:
    root_node = priority_q.shift
    BinaryTree.new(root_node)
  end

  def build_byte_to_code_table(binary_tree)
    byte_to_code = {}
    binary_tree.traverse_preorder(lambda { |node, path| byte_to_code[node.byte] = path.join()} )
    byte_to_code
  end

  def get_frequencies(input_file)
    frequencies = {}

    # TODO: pre-populate frequencies with 0 to skip .nil? check.

    input_file.each_byte do |k|
      frequencies[k] = if frequencies[k].nil? then 1 else (frequencies[k] + 1) end
    end

    frequencies.to_a.sort_by! { |k, v| v }
  end
end

def file_length_bits(filename)
  File.size('sample.txt') * 8
end


# testing things out:
input_file = File.open(INPUT_FILE_NAME, 'r')
output_file = File.open(OUTPUT_FILE_NAME, 'wb')
encoder = HuffmanEncoder.new(input_file)

encoder.output_to_file(output_file)
compressed = encoder.output_as_string

input_file.close
output_file.close

puts compressed
output_size_bits = compressed.length
input_size_bits = File.size(INPUT_FILE_NAME) * 8
delta_bits = input_size_bits - output_size_bits
puts "Original file size: %i bits" % input_size_bits
puts "Encoded file size: %i bits" % output_size_bits
puts "Saved space: %i bits" % delta_bits
puts "Space savings: %.2f%" % ((1 - output_size_bits * 1.0 / input_size_bits) * 100)

# puts encoder.decode(compressed)