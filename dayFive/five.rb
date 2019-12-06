# 1002,4,3,4,33
#
#
class Integer
  def digits(base: 10)
    quotient, remainder = divmod(base)
    quotient.zero? ? [remainder] : [*quotient.digits(base: base), remainder]
  end
end

class DayFive
  def initialize(program, input)
    @program = program.split(',').map(&:to_i)
    @input = input
  end

  def run_code
    i = 0
    while @program[i] != 99 do
      x = @program[i]
      params = x.digits.count >= 2 && x != 99 ? parse_parameter_code(x) : {de: x, c: 0, b: 0, a: 0}
      case params[:de]
      when 1
        addition(i, params)
        i += 4
      when 2
        multiplication(i, params)
        i += 4
      when 3
        @program[@program[i + 1]] = @input
        i += 2
      when 4
        output = params[:c].zero? ? @program[@program[i + 1]] : @program[i + 1]
        puts output
        i += 2
      when 5
        inc = jump(i, params, true)
        i = inc
      when 6
        inc = jump(i, params, false)
        i = inc
      when 7
        less_than(i, params)
        i += 4
      when 8
        equal_to(i, params)
        i += 4
      end
    end
    @program[0]
  end

  def addition(i, params)
    c = params[:c].zero? ? @program[@program[i + 1]] : @program[i + 1]
    b = params[:b].zero? ? @program[@program[i + 2]] : @program[i + 2]
    a = params[:a].zero? ? @program[i + 3] : i + 3
    @program[a] = c + b
  end

  def multiplication(i, params)
    c = params[:c].zero? ? @program[@program[i + 1]] : @program[i + 1]
    b = params[:b].zero? ? @program[@program[i + 2]] : @program[i + 2]
    a = params[:a].zero? ? @program[i + 3] : i + 3
    @program[a] = c * b
  end

  def jump(i, params, if_true)
    c = params[:c].zero? ? @program[@program[i + 1]] : @program[i + 1]
    b = params[:b].zero? ? @program[@program[i + 2]] : @program[i + 2]

    return c.abs.positive? ? b : i + 3 if if_true

    c.zero? ? b : i + 3
  end

  def less_than(i, params)
    c = params[:c].zero? ? @program[@program[i + 1]] : @program[i + 1]
    b = params[:b].zero? ? @program[@program[i + 2]] : @program[i + 2]
    a = params[:a].zero? ? @program[i + 3] : i + 3
    @program[a] = c < b ? 1 : 0
  end

  def equal_to(i, params)
    c = params[:c].zero? ? @program[@program[i + 1]] : @program[i + 1]
    b = params[:b].zero? ? @program[@program[i + 2]] : @program[i + 2]
    a = params[:a].zero? ? @program[i + 3] : i + 3
    @program[a] = c == b ? 1 : 0
  end

  def parse_parameter_code(code)
    digits = code.digits
    digits.unshift(0) while digits.count < 5
    op = digits[-1] == 9 ? 99 : digits[-1]
    {de: op, c: digits[-3], b: digits[-4], a: digits[-5]}
  end
end

file = File.open('input.txt').read
#file = '1002,4,3,4,33'
input = 1

p1 = DayFive.new(file, input)
puts '###### Part 1 ######'
output = p1.run_code
puts "#{output}"

puts '###### Part 2 #####'
p2 = DayFive.new(file, 5)
output = p2.run_code
puts output