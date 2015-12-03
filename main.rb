require 'pp'
require 'profile'

inputFile = File.open('sample.txt', 'r')

def getFrequencies(inputFile)
  frequencies = {}

  # TODO: pre-populate frequencies with 0 to skip .nil? check.

  inputFile.each_byte do |k|
    frequencies[k] = if frequencies[k].nil? then 0 else (frequencies[k] + 1) end
  end

  frequencies.to_a.sort_by! { |k, v| v } .reverse
end

pp getFrequencies(inputFile)