module BTree
  class BinaryTreeNode
    attr_accessor :byte, :freq, :left_node, :right_node
    def initialize(byte=nil, freq=nil, left_node=nil, right_node=nil)
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
end