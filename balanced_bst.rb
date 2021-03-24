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

    replacement_parent = parent(replacement_node.data)

    node_to_delete.data = replacement_node.data

    if replacement_node.data == node_to_delete.right_child.data
      node_to_delete.right_child = node_to_delete.right_child.right_child
    else
      replacement_parent.left_child = replacement_node.right_child
    end
  end
end

# Module managing the ordering of nodes
module Ordering
  def level_order
    return if @root.nil?

    data = ''
    queue = []
    queue.push(@root)
    print_level(queue, data)
  end

  def preorder
    data = ''
    print_preorder(@root, data)
  end

  def inorder
    data = ''
    print_inorder(@root, data)
  end

  def postorder
    data = ''
    print_postorder(@root, data)
  end

  private

  def print_level(queue, data)
    return data if queue.empty?

    current = queue.first
    data = "#{data}#{current.data} "
    queue.push(current.left_child) unless current.left_child.nil?
    queue.push(current.right_child) unless current.right_child.nil?
    queue.shift

    print_level(queue, data)
  end

  def print_preorder(node, data)
    return data if node.nil?

    data = "#{data}#{node.data} "
    data = print_preorder(node.left_child, data)
    print_preorder(node.right_child, data)
  end

  def print_inorder(node, data)
    return data if node.nil?

    data = print_inorder(node.left_child, data)
    data = "#{data}#{node.data} "
    print_inorder(node.right_child, data)
  end

  def print_postorder(node, data)
    return data if node.nil?

    data = print_postorder(node.left_child, data)
    data = print_postorder(node.right_child, data)
    "#{data}#{node.data} "
  end
end

# Module that measures the metrics of the binary search tree
module Metrics
  def height(value)
    node = find(value)
    p find_height(node)
  end

  def depth(value)
    node = find(value)
    p find_depth(node)
  end

  def balanced?
    check_balance(@root)
  end

  def rebalance
    @array = inorder.split(' ').map(&:to_i)
    @root = build_tree(@array, 0, @array.length - 1)
  end

  private

  def find_height(node)
    return -1 if node.nil?

    left_height = find_height(node.left_child)
    right_height = find_height(node.right_child)
    [left_height, right_height].max + 1
  end

  def find_depth(node)
    return 0 if node == @root

    1 + find_depth(parent(node.data))
  end

  def check_balance(node)
    return true if node.nil?

    left_height = find_height(node.left_child)
    right_height = find_height(node.right_child)

    return false if (left_height - right_height).abs > 1

    check_balance(node.left_child)
    check_balance(node.right_child)
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
  include Ordering
  include Metrics

  def initialize(array)
    @array = array.sort.uniq
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
    leaf_node = find(value)
    if value < leaf_node.data
      leaf_node.left_child = Node.new(value)
    elsif value > leaf_node.data
      leaf_node.right_child = Node.new(value)
    else
      puts "Attempt to insert value #{value} into the binary search tree failed.  This value already exists!"
    end
  end

  def delete(value)
    node_to_delete = find(value)
    parent_node = parent(value)
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

  def find(value, node = @root)
    if value < node.data
      return node if node.left_child.nil?

      find(value, node.left_child)
    elsif value > node.data
      return node if node.right_child.nil?

      find(value, node.right_child)
    else
      node
    end
  end

  private

  def no_of_children(node)
    if node.left_child.nil? && node.right_child.nil?
      0
    elsif node.left_child.nil? || node.right_child.nil?
      1
    else
      2
    end
  end

  def parent(value, node = @root)
    if value < node.data
      return node if node.left_child.data == value

      parent(value, node.left_child)
    elsif value > node.data
      return node if node.right_child.data == value

      parent(value, node.right_child)
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

def balance_script(bst)
  puts "This binary search tree #{bst.balanced? ? 'IS ' : 'IS NOT '}balanced"
end

def order_script(bst)
  puts " \n"
  puts 'This is the array outputted using different ordering methods'
  puts "Level: #{bst.level_order}"
  puts "Pre: #{bst.preorder}"
  puts "Post: #{bst.postorder}"
  puts "In: #{bst.inorder}"
  puts " \n"
end

array = Array.new(15) { rand(1..100) }

puts 'This is the sample array of 15 numbers'
p array

bst = Tree.new(array)

puts 'This is the binary search tree created from that array'
bst.pretty_print(true)

balance_script(bst)
order_script(bst)

array2 = Array.new(3) { rand(101..1000) }

puts "This is the binary search tree after the randomly generated numbers, #{array2[0]}, #{array2[1]} and "\
"#{array2[2]} have been inserted into it"

array2.each { |num| bst.insert(num) }

bst.pretty_print(true)
balance_script(bst)
puts " \n"

puts 'This is the binary search tree after it has been rebalanced'
bst.rebalance
bst.pretty_print(true)

balance_script(bst)
order_script(bst)
