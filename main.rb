require 'pp'

inputFile = File.open('sample.txt', 'r')

def getFrequencies(inputFile)
  frequencies = {}

  inputFile.each_byte do |k|
    frequencies[k] = if frequencies[k].nil? then 0 else (frequencies[k] + 1) end
  end

  frequencies
end

pp getFrequencies(inputFile)