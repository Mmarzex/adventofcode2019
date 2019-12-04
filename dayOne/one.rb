
File.open('input.txt') do |f|
    total_mass = 0
    f.each_line do |line|
        mass = line.to_i
        total_mass = total_mass + (mass/3).floor - 2
    end
    puts "Part One Mass: #{total_mass}"
end

def calculate_mass(mass)
    (mass/3).floor - 2
end

def calculate_mass_i(mass)
    total_mass = calculate_mass(mass)
    m = total_mass
    until m <= 0
        new_mass = calculate_mass(m)
        if new_mass <= 0
            return total_mass
        end
        total_mass = total_mass + new_mass
        m = new_mass
    end
    total_mass
end

def calculate_fuel(fuel)
    return 0 if fuel < 7
    total_mass = 0
    m = calculate_mass(fuel)
    m += calculate_fuel(m)
    m
end

File.open('input.txt') do |f|
    total_mass = 0
    r_mass = 0
    f.each_line do |line|
        mass = line.to_i
        total_mass = total_mass + calculate_mass_i(mass) 
        r_mass += calculate_fuel(mass)
    end
    puts "Part Two Mass: #{total_mass}"
    puts "Part Two Fuel Recursive: #{r_mass}"
end

# 4931715 