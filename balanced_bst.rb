# frozen_string_literal: true

# Module for managing the deletion of nodes
module DeleteNodes
  private

  def delete_none(parent_node)
    if parent_node.left_child.nil?
      parent_node.right_child = nil
    else
      parent_node.left_child = nil
    end
  end

  def delete_one(parent_node, node_to_delete)
    new_child_node = node_to_delete.left_child.nil? ? node_to_delete.right_child : node_to_delete.left_child

    if node_to_delete.data < parent_node.data
      parent_node.left_child = new_child_node
    else
      parent_node.right_child = new_child_node
    end
  end

  def delete_two(node_to_delete)
    replacement_node = get_smallest(node_to_delete.right_child)

    replacement_parent = parent(@root, replacement_node.data)

    node_to_delete.data = replacement_node.data

    if replacement_node.data == node_to_delete.right_child.data
      node_to_delete.right_child = node_to_delete.right_child.right_child
    else
      replacement_parent.left_child = replacement_node.right_child
    end

    # return unless node_to_delete.data == node_to_delete.right_child.data

    # node_to_delete.right_child = node_to_delete.right_child.right_child
  end
end

# Node class which holds information on about each node of the binary search tree
class Node
  attr_accessor :data, :left_child, :right_child

  def initialize(data, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end
end

# Tree class that builds the binary search tree made up of node objects
class Tree
  include DeleteNodes

  def initialize(array)
    @array = array.sort.uniq
    p @array
    @root = build_tree(@array, 0, @array.length - 1)
  end

  def build_tree(array, a_start, a_end)
    return nil if a_start > a_end

    mid = (a_start + a_end) / 2

    root = Node.new(array[mid])

    root.left_child = build_tree(array, a_start, mid - 1)
    root.right_child = build_tree(array, mid + 1, a_end)
    root
  end

  def insert(value)
    leaf_node = find(@root, value)
    if value < leaf_node.data
      leaf_node.left_child = Node.new(value)
    elsif value > leaf_node.data
      leaf_node.right_child = Node.new(value)
    else
      puts "Attempt to insert value #{value} into the binary search tree failed.  This value already exists!"
    end
  end

  def delete(value)
    node_to_delete = find(@root, value)
    parent_node = parent(@root, value)
    case no_of_children(node_to_delete)
    when 0
      delete_none(parent_node)
    when 1
      delete_one(parent_node, node_to_delete)
    when 2
      delete_two(node_to_delete)
    end
  end

  def pretty_print(is_left, node = @root, prefix = '')
    pretty_print(false, node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}") if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(true, node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}") if node.left_child
  end

  private

  def find(node, value)
    if value < node.data
      return node if node.left_child.nil?

      find(node.left_child, value)
    elsif value > node.data
      return node if node.right_child.nil?

      find(node.right_child, value)
    else
      node
    end
  end

  def no_of_children(node)
    if node.left_child.nil? && node.right_child.nil?
      0
    elsif node.left_child.nil? || node.right_child.nil?
      1
    else
      2
    end
  end

  def parent(node, value)
    if value < node.data
      return node if node.left_child.data == value

      parent(node.left_child, value)
    elsif value > node.data
      return node if node.right_child.data == value

      parent(node.right_child, value)
    else
      node
    end
  end

  def get_smallest(node)
    return node if node.left_child.nil?

    next_smallest_node = node.left_child
    get_smallest(next_smallest_node)
  end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

bst = Tree.new(array)

bst.insert(286)

bst.insert(290)

bst.delete(23)

bst.delete(7)

bst.pretty_print(true)

bst.delete(4)

bst.pretty_print(true)

bst.insert(50)

bst.pretty_print(true)

bst.delete(8)

bst.delete(9)

bst.pretty_print(true)
