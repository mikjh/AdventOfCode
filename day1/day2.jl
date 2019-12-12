function fuelFromMass(mass)
    return convert(Int64,floor(mass/3)-2)
end

function totalFuel(mass)
    totalFuel = 0::Int64
    fuel = fuelFromMass(mass)
    while(fuel > 0)
        totalFuel += fuel
        fuel = fuelFromMass(fuel)
    end

    return totalFuel
end
        



numOfLines = open("./input.txt") do file
    requiredFuel = 0::Int64

    lines = readlines(file)
    for line in lines
        mass = parse(Int64, line)
        requiredFuel += totalFuel(mass)
    end

    print(requiredFuel)
    #print(frequency)
end

using Test
@test fuelFromMass(12) == 2
@test fuelFromMass(14) == 2
@test fuelFromMass(1969) == 654
@test fuelFromMass(100756) == 33583

@test totalFuel(14) == 2
@test totalFuel(1969) == 966
@test totalFuel(100756) == 50346