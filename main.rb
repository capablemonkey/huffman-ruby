require 'pp'
# require 'profile' # to determine performance bottlenecks
require_relative 'binary_tree.rb'
require_relative 'huffman.rb'

INPUT_FILE_NAME = 'sample.txt'
OUTPUT_FILE_NAME = 'output.txt'

def file_length_bits(filename)
  File.size('sample.txt') * 8
end

# testing things out:
input_file = File.open(INPUT_FILE_NAME, 'r')
output_file = File.open(OUTPUT_FILE_NAME, 'wb')
encoder = Huffman::Encoder.new(input_file)

encoder.output_to_file(output_file)
compressed = encoder.output_as_string

input_file.close
output_file.close

# puts compressed
output_size_bits = compressed.length
input_size_bits = File.size(INPUT_FILE_NAME) * 8
delta_bits = input_size_bits - output_size_bits
puts "Original file size: %i bits" % input_size_bits
puts "Encoded file size: %i bits" % output_size_bits
puts "Saved space: %i bits" % delta_bits
puts "Space savings: %.2f%" % ((1 - output_size_bits * 1.0 / input_size_bits) * 100)

# puts encoder.decode(compressed)