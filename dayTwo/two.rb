
def run_code(input, noun=12, verb=2)
    i = 0
    input[1] = noun
    input[2] = verb
    while input[i] != 99 do
        x = input[i]
        if x == 1
            input[input[i+3]] = input[input[i+1]] + input[input[i+2]]
            i += 3
        elsif x == 2
            input[input[i+3]] = input[input[i+1]] * input[input[i+2]]
            i += 3
        elsif x == 99
            return input[0]
        end
        i += 1
    end
    return input[0]
end

def run_p2(input)
    (0..99).each do |noun|
        (0..99).each do |verb|
            output = run_code(input.dup, noun, verb)
            if output == 19690720
                return 100 * noun + verb
            end
        end
    end
end

file = File.open('input.txt').read
input = file.split(',').map(&:to_i)
p1_answer = run_code(input.dup)
puts "P1: #{p1_answer}"
puts "P2: #{run_p2(input.dup)}"
