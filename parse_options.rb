require 'optparse'

def parse_options
  options = {}

  optparse = OptionParser.new do |parser|
    parser.banner = 'usage: ruby main.rb [options]'
    parser.on('-e', '--encode', 'Encoding mode') {|e| options[:encode] = e}
    parser.on('-d', '--decode', 'Decoding mode') {|e| options[:decode] = e}
    parser.on('-c', '--console-output', 'Dump output file content to STDOUT') {|e| options[:console_output] = e}
    parser.on('-i', '--input INPUT_FILE', 'Input file. The file to be encoded or decoded.') {|e| options[:input_file] = e}
    parser.on('-o', '--output OUTPUT_FILE', 'Output file, where result of decoding or encoding will be written to.') {|e| options[:output_file] = e}
  end

  optparse.parse!

  def check_options(message, error_found)
    return unless error_found
    warn message
    puts $optparse
    exit(false)
  end

  check_options 'No operation mode selected.  Use -d or -e', (options[:encode].nil? && options[:decode].nil?)
  check_options 'Only one operation mode can be selected: either -e or -d.', (options[:encode] && options[:decode])
  check_options 'Input and output file must be specified using -i and -o', (options[:input_file].nil? || options[:output_file].nil?)

  options
end