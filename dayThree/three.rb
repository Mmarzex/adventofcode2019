require 'set'

# f = File.readlines('input.txt')
# # wire_one = 'R8,U5,L5,D3'
# # wire_two = 'U7,R6,D4,L4'

# wire_one = f[0]
# wire_two = f[1]

class DayThree
  def initialize(wire_one, wire_two)
    @wire_one = wire_one.split(',').map { |v| { :direction => v[0], :steps => v[1..-1].to_i }}
    @wire_two = wire_two.split(',').map { |v| { :direction => v[0], :steps => v[1..-1].to_i }}
  end
  
  def run
    wire_one_points = get_points(@wire_one)
    wire_two_points = get_points(@wire_two)
    p1_set = (Set.new(wire_one_points.map { |v| {:x => v[:x], :y => v[:y]}}) & Set.new(wire_two_points.map { |v| {:x => v[:x], :y => v[:y]}})).to_a

    p2_wire_one = wire_one_points.select do |v|
      point = { :x => v[:x], :y => v[:y] }
      p1_set.include?(point)
    end

    p2_wire_two = wire_two_points.select do |v|
      point = { :x => v[:x], :y => v[:y] }
      p1_set.include?(point)
    end

    res = {}

    p2_wire_one.each { |v| res[v[:x] + v[:y]] = v[:steps] }
    p2_wire_two.each { |v| res[v[:x] + v[:y]] += v[:steps] }

    puts "#{p1_set.map { |v| v[:x].abs + v[:y].abs }.min}"
    puts "#{res.values.min}"
    { :p1 => p1_set.map { |v| v[:x].abs + v[:y].abs }.min, :p2 => res.values.min }
    
  end
  
  private
  
  def get_points(wire)
    points = []
    steps = 0
    current_point = { :x => 0, :y => 0 }
    wire.each do |v|
      (0...v[:steps]).each do |x|
        steps += 1
        case v[:direction]
        when 'R'
          current_point[:x] += 1
        when 'L'
          current_point[:x] -= 1
        when 'U'
          current_point[:y] += 1
        when 'D'
          current_point[:y] -= 1
        else
          puts "OH NO"
        end
        points << { :x => current_point[:x], :y => current_point[:y], :steps => steps }
      end
    end
    points
  end
end

# wire_one_parsed = wire_one.split(',').map do |v|
#     { :direction => v[0], :steps => v[1..-1].to_i }
# end

# wire_two_parsed = wire_two.split(',').map do |v|
#     { :direction => v[0], :steps => v[1..-1].to_i }
# end
# # puts "#{wire_one_parsed}"
# # puts "#{wire_two_parsed}"

# wire_one_points = []
# steps = 0
# current_point = { :x => 0, :y => 0 }

# wire_one_parsed.each do |v|
#     (0...v[:steps]).each do |x|
#         steps += 1
#         case v[:direction]
#         when 'R'
#             current_point[:x] += 1
#         when 'L'
#             current_point[:x] -= 1
#         when 'U'
#             current_point[:y] += 1
#         when 'D'
#             current_point[:y] -= 1
#         else
#             puts "OH NO"
#         end
#         wire_one_points << { :x => current_point[:x], :y => current_point[:y], :steps => steps }
#     end
# end

# steps = 0
# current_point = { :x => 0, :y => 0 }
# wire_two_points = []
# wire_two_parsed.each do |v|
#     (0...v[:steps]).each do |x|
#         steps += 1
#         case v[:direction]
#         when 'R'
#             current_point[:x] += 1
#         when 'L'
#             current_point[:x] -= 1
#         when 'U'
#             current_point[:y] += 1
#         when 'D'
#             current_point[:y] -= 1
#         else
#             puts "OH NO"
#         end
#         wire_two_points << { :x => current_point[:x], :y => current_point[:y], :steps => steps }
#     end
# end

# p1_set = (Set.new(wire_one_points.map { |v| {:x => v[:x], :y => v[:y]}}) & Set.new(wire_two_points.map { |v| {:x => v[:x], :y => v[:y]}})).to_a

# p2_wire_one = wire_one_points.select do |v|
#     point = { :x => v[:x], :y => v[:y] }
#     p1_set.include?(point)
# end

# p2_wire_two = wire_two_points.select do |v|
#     point = { :x => v[:x], :y => v[:y] }
#     p1_set.include?(point)
# end

# res = {}

# p2_wire_one.each { |v| res[v[:x] + v[:y]] = v[:steps] }
# p2_wire_two.each { |v| res[v[:x] + v[:y]] += v[:steps] }

# puts "#{p1_set.map { |v| v[:x].abs + v[:y].abs }.min}"
# puts "#{res.values.min}"

# p = DayThree.new(wire_one, wire_two)
# p.run
# unoptimized 9.319s