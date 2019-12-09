require 'set'
Node = Struct.new(:value, :distance, :parent, :left, :right)

class Tree
  attr_accessor :children, :name

  def initialize(v)
    @name = v
    @children = []
  end
end


class DaySix
  def initialize(input)
    @input = input.map(&:strip).map { |x| x.split(')') }
    @children = {}
    @input.each do |v|
      if @children.key?(v[0])
        @children[v[0]] << v[1]
      else
        @children[v[0]] = [v[1]]
      end
    end
    @unique_nodes = Set.new(@children.values.flatten).to_a
  end

  def create_tree_p2(root)
    return unless @children.key?(root.name)

    @children[root.name].each do |n|
      temp = Tree.new(n)
      @san = temp if n == 'SAN'
      @you = temp if n == 'YOU'
      root.children << temp
      create_tree_p2(temp)
    end
  end

  def create_subtree(parent, key, distance_from_com)
    new_node = Node.new(key, distance_from_com, parent)
    return new_node unless @children.key?(key)

    #puts "#{key} count: @children[#{key}] #{@children[key]}"
    if @children[key].count == 2
      new_node.left = create_subtree(new_node, @children[key][0], distance_from_com + 1)
      new_node.right = create_subtree(new_node, @children[key][1], distance_from_com + 1)
    elsif @children[key].count == 1
      new_node.left = create_subtree(new_node, @children[key][0], distance_from_com + 1)
    end
    new_node
  end

  def get_indirect_orbits(root)
    return root.distance - 1 unless root.left.nil? && root.right.nil?
    if !root.left.nil? && !root.right.nil?
      return (root.left.distance - 1) + (root.right.distance - 1) + get_indirect_orbits(root.left) + get_indirect_orbits(root.right)
    elsif !root.left.nil?
      return (root.left.distance - 1) + get_indirect_orbits(root.left)
    elsif !root.right.nil?
      return (root.right.distance - 1) + get_indirect_orbits(root.right)
    end
  end

  def calculate_indirect(root)
    current = root
    data = []
    distance = 0
    loop do
      if current.nil?
        return distance if data.empty?

        current = data.pop
        distance += (current.distance - 1) if current.value != 'COM'
        current = current.right
      else
        data << current
        current = current.left
      end
    end
  end

  def paths(node, path = '', &proc)
    if node.left.nil? && node.right.nil?
      proc.call(path + node.value)
    else
      paths(node.left, path + node.value, &proc) unless node.left.nil?
      paths(node.right, path + node.value, &proc) unless node.right.nil?
    end
  end

  def inorder(root)
    return if root.nil?

    inorder(root.left)
    print "#{root.distance - 1} "
    inorder(root.right)
  end

  def paths_two(node,path='',&proc)
    if node.children.empty?
      proc.call(path+node.name+',')
    else
      node.children.each{|c| paths_two(c,path+node.name+',',&proc)}
    end
  end

  def create_tree
    puts @children
    puts "Length of unique #{@unique_nodes.length}"
    root = create_subtree(nil, 'COM', 0)
    indirects = calculate_indirect(root)
    puts "Indirects #{indirects} Uniques #{@unique_nodes.length} Total: #{indirects + @unique_nodes.length}"
    paths(root) { |path| puts path }
    root
  end

  def part_two
    puts @children
    root = Tree.new('COM')
    create_tree_p2(root)
    puts root
    d = []
    paths_two(root) do |path|
      d << path if path.include?('YOU') || path.include?('SAN')
    end
    s = d.map { |x| x.split(',') }.map { |x| Set.new(x[0..-2]) }
    ss = (s[0] - s[1]).length + (s[1] - s[0]).length
    #puts s[0]
    puts ss
  end
end

f = File.readlines('input_real.txt')
d = DaySix.new(f)
d.part_two
#r = d.create_tree
# I think I don't have to worry about COM being included in unique array, need to think though