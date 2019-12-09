input = '123456789012'

class DayEight
  def initialize(input, width, height)
    @input = input.split('').map(&:to_i)
    @w = width
    @h = height
    @pixels_per_layer = width * height
    @layers = @input.each_slice(@pixels_per_layer).to_a
  end

  def part_one
    x = @layers.min { |a, b| a.count(0) <=> b.count(0) }
    x.count(1) * x.count(2)
  end

  def part_two
    result = @layers.transpose.map { |layer| determine_color(layer) }.each_slice(@w).to_a
    result.each do |l|
      puts l.each { |p| p }.join('')
    end
  end
  
  private
  
  def determine_color(layer)
    #layer[0] if layer[0].zero? || (layer[0] == 1)
    layer.find { |p| p.zero? || p == 1 }
  end
end

p2_input = '0222112222120000'
#d = DayEight.new(p2_input, 2, 2)
d = DayEight.new(File.open('input.txt').read, 25, 6)
puts "#{d.part_one}"
d.part_two
#puts "#{d.part_two}"