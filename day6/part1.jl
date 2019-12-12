function getNumOfSatelites(orbits, planet)
    satelites = get(orbits,planet,[])
    
    num_of_satelites = 0
    for satelite in satelites
        num_of_satelites += getNumOfSatelites(orbits,satelite)+1
    end

    return num_of_satelites
end

function getTotSatelites(orbits)
    sum = 0
    for (planet,satelite) in orbits
        sum += getNumOfSatelites(orbits,planet)
    end
    return sum
end

function getOrbits(lines)
    orbits = Dict{String, Any}()
    for line in lines
        m = match(r"(.*)\)(.*)",line)
        planet = m[1]        
        satelite = m[2]

        satelites = get(orbits,planet,String[])
        push!(satelites,satelite)
        orbits[planet] = satelites
    end
    return orbits
end
function part1(lines)
    orbits = getOrbits(lines)
    #println(orbits)

    return getTotSatelites(orbits)
end

using Test

@test part1(["A)B"]) == 1
@test part1(["A)B","C)D"]) == 2
@test part1(["A)B","B)C"]) == 3

open("input.txt") do f
    println(part1(readlines(f)))
end