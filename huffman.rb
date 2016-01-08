require_relative 'binary_tree'

module Huffman
  class Encoder
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
      # determine inverse of the huffman table (code -> byte)
      @decoding = @encoding.invert

      # iterate through bits and replace match sequences of bits with their huffman encoding.
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
        priority_q.push BTree::BinaryTreeNode.new(byte, freq)
      end

      while priority_q.size > 1
        first = priority_q.shift
        second = priority_q.shift
        combined_frequency = first.freq + second.freq
        internal_node = BTree::BinaryTreeNode.new(nil, combined_frequency, first, second)
        priority_q.push(internal_node)
        priority_q.sort_by! { |node| node.freq }
      end

      # when there's only one node left, that's the root node:
      root_node = priority_q.shift
      BTree::BinaryTree.new(root_node)
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

      frequencies.to_a.sort_by! { |_, v| v }
    end
  end
end