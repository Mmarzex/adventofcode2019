# 1002,4,3,4,33
#
#
class Integer
  def digits(base: 10)
    quotient, remainder = divmod(base)
    quotient.zero? ? [remainder] : [*quotient.digits(base: base), remainder]
  end
end

class IntcodeComputer
  attr_reader :halted, :outputs

  def initialize(program, input, halt_on_output = false)
    @program = program.split(',').map(&:to_i)
    @program_str = program
    @input = input.clone
    #@phase = phase
    @outputs = []
    @halt_on_output = halt_on_output
    @idx = 0
  end

  def reset_computer(input, phase)
    @program = @program_str.split(',').map(&:to_i)
    @input = [input, phase]
    @phase = phase
    @outputs = []
    @halted = false
    @idx = 0
  end

  def add_input(input)
    @input << input
  end

  def run_code(*input)
    @input += input if input.any?
    #i = 0
    until @halted
      #puts @idx
      x = @program[@idx]
      params = x.digits.count >= 2 && x != 99 ? parse_parameter_code(x) : {de: x, c: 0, b: 0, a: 0}
      case params[:de]
      when 1
        addition(@idx, params)
        @idx += 4
      when 2
        multiplication(@idx, params)
        @idx += 4
      when 3
        @program[@program[@idx + 1]] = @input.pop
        @idx += 2
      when 4
        puts "issue" if !params[:c].zero?
        output = params[:c].zero? ? @program[@program[@idx + 1]] : @program[@idx + 1]
        puts "Output #{output}" if output == 139_629_729
        @outputs << output
        @idx += 2
        puts "Outputs: #{@outputs}" if output == 139_629_729
        return output if @halt_on_output
      when 5
        inc = jump(@idx, params, true)
        @idx = inc
      when 6
        inc = jump(@idx, params, false)
        @idx = inc
      when 7
        less_than(@idx, params)
        @idx += 4
      when 8
        equal_to(@idx, params)
        @idx += 4
      when 99
        @halted = true
      end
    end
    @outputs.last
    #{ p: @program[0], output: @outputs }
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

class DaySeven
  def initialize
    @input = File.open('input.txt').read
    @computer = IntcodeComputer.new(@input, [0, 0])
  end

  def part_one
    phases = [0, 1, 2, 3, 4].permutation(5).to_a
    thrusts = phases.map { |p| run_code(p) }
    thrusts
  end

  def part_two
    phases = [5, 6, 7, 8, 9].permutation(5).to_a
    thrusts = phases.map { |p| run_part_two_code(p) }
    thrusts
  end

  private

  def run_code(phases)
    thrust = phases.reduce(0) do |mem, p|
      @computer.reset_computer(mem, p)
      out = @computer.run_code
      out
    end
    thrust
  end

  def run_part_two_code(phases)
    computers = phases.map { |p| IntcodeComputer.new(@input, [p], true) }
    i = 0
    until computers.last.halted
      i = computers.reduce(i) { |val, amp| amp.run_code(val) }
    end
    computers.last.outputs.last
  end
end


d = DaySeven.new

#thrusts = d.part_one

#puts "Thrusts: #{thrusts.max}"

puts "Part two: #{d.part_two.max}"