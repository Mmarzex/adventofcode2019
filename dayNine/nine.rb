require 'pry'
class IntcodeComputer
  attr_reader :outputs
  def initialize(program, *input, halt_on_output: false)
    @program = program.split(',').map(&:to_i)
    @program_str = program
    @input = input.clone
    @outputs = []
    @halt_on_output = halt_on_output
    @idx = 0
    @relative_base = 0
  end

  def run(*input)
    #binding.pry
    @input += input if input.any?
    until halted?
      code = @program[@idx] % 100
      a, b, c = @program[@idx + 1, 3]
      a = @program[a] if @program[@idx].div(100).modulo(10).zero?
      b = @program[b] if @program[@idx].div(1000).modulo(10).zero?
      if @program[@idx].div(100).modulo(10) == 2
        a = @program[@relative_base + a]
      end
      if @program[@idx].div(1000).modulo(10) == 2
        b = @program[@relative_base + b]
      end
      a = 0 if a.nil?
      b = 0 if b.nil?
      if @program[@idx].div(10_000).modulo(10) == 2
        c = @program[@idx + 3] + @relative_base
      end
      case code
      when 1
        @program[c] = a + b
        @idx += 4
      when 2
        @program[c] = a * b
        @idx += 4
      when 3
        #binding.pry
        # Don't trust this
        if @program[@idx].div(100).modulo(10) == 2
          #binding.pry
          i = @program[@idx + 1].nil? ? 0 : @program[@idx + 1]
          i += @relative_base
          @program[i] = @input.shift
        else
          @program[@program[@idx + 1]] == @input.shift
        end
        @idx += 2
      when 4
        @outputs << a
        @idx += 2
        return @outputs.last if @halt_on_output
      when 5
        @idx = !a.zero? ? b : @idx + 3
      when 6
        @idx = a.zero? ? b : @idx + 3
      when 7
        @program[c] = a < b ? 1 : 0
        @idx += 4
      when 8
        @program[c] = a == b ? 1 : 0
        @idx += 4
      when 9
        #binding.pry
        @relative_base += a
        @idx += 2
      end
    end
    @outputs.last
  end

  def halted?
    @program[@idx] % 100 == 99
  end
end

x = IntcodeComputer.new(File.open('input.txt').read, 1)
# x = IntcodeComputer.new('109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99')
p x.run

p2 = IntcodeComputer.new(File.open('input.txt').read, 2)
p p2.run
