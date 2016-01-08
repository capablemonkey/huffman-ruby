require 'pp'
# require 'profile' # to determine performance bottlenecks
require_relative 'huffman.rb'
require_relative 'parse_options.rb'

def file_length_bits(filename)
  File.size('sample.txt') * 8
end

options = parse_options

if options[:encode]
  input_file = File.open(options[:input_file], 'r')
  output_file = File.open(options[:output_file], 'wb')
  encoder = Huffman::Encoder.new(input_file)

  encoder.output_to_file(output_file)
  compressed = encoder.output_as_string

  if options[:console_output] then puts compressed end

  input_file.close
  output_file.close

  output_size_bits = compressed.length
  input_size_bits = File.size(options[:input_file]) * 8
  delta_bits = input_size_bits - output_size_bits
  puts "Original file size: %i bits" % input_size_bits
  puts "Encoded file size: %i bits" % output_size_bits
  puts "Saved space: %i bits" % delta_bits
  puts "Space savings: %.2f%" % ((1 - output_size_bits * 1.0 / input_size_bits) * 100)
end

if options[:decode]
  warn 'Decode is not implemented yet!'
  # puts encoder.decode(compressed)
end

