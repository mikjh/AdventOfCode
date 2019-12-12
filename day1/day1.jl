function fuel(mass)
    return convert(Int64,floor(mass/3)-2)
end

numOfLines = open("./input.txt") do file
    requiredFuel = 0::Int64

    lines = readlines(file)
    for line in lines
        print("line: ")
        print(line)
        mass = parse(Int64, line)
        print(" : ")
        println(mass)
        requiredFuel += fuel(mass)
    end

    print(requiredFuel)
    #print(frequency)
end

using Test
@test fuel(12) == 2
@test fuel(14) == 2
@test fuel(1969) == 654
@test fuel(100756) == 33583