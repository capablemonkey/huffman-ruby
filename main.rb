require 'pp'
# require 'profile'

input_file = File.open('sample.txt', 'r')

def getFrequencies(input_file)
  frequencies = {}

  # TODO: pre-populate frequencies with 0 to skip .nil? check.

  input_file.each_byte do |k|
    frequencies[k] = if frequencies[k].nil? then 1 else (frequencies[k] + 1) end
  end

  frequencies.to_a.sort_by! { |k, v| v }
end

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
    @current_node = root_node
  end

  def traverse(proc, current=nil)
    current = if current then current else @root_node end

    if current.leaf? and current.byte
      #puts current.freq.to_s << ':' << current.byte
      return proc.call(current)
    end

    if current.left_node
      self.traverse(proc, current.left_node)
    end

    if current.right_node
      self.traverse(proc, current.right_node)
    end
  end
end

def buildTreeFromFrequencies(frequencies)
  # Turn each (byte, frequency) tuple into a Node and add to priority queue:
  priority_q = []

  frequencies.each do | byte, freq |
    priority_q.push BinaryTreeNode.new(byte, freq)
  end

  # construct tree from bottom:
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

frequencies = getFrequencies(input_file)
binary_tree = buildTreeFromFrequencies(frequencies)

binary_tree.traverse(lambda { |node| pp node.freq })