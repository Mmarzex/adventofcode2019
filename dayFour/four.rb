class Integer
    def digits(base: 10)
      quotient, remainder = divmod(base)
      quotient == 0 ? [remainder] : [*quotient.digits(base: base), remainder]
    end
end

input_lower = 245182
input_upper = 790572

def is_valid_password?(input, part_two=false)
    digits = input.digits
    prev = digits[0]
    is_double = false
    is_asc = true

    1.upto(digits.count - 1).each do |v|
        new_dig = digits[v]
        if part_two
            is_double = true if prev == new_dig && prev != digits[v - 2] && new_dig != digits[v + 1]
        else
            is_double = true if new_dig == prev
        end
        is_asc = false if new_dig < prev
        prev = new_dig
    end
    is_double && is_asc
end
p1_result = (input_lower..input_upper).filter do |x|
    is_valid_password?(x)
end
p2_result = (input_lower..input_upper).filter do |x|
    is_valid_password?(x, true)
end
puts "#{p1_result.count}"
puts "#{p2_result.count}"

