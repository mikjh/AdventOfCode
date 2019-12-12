function getNumOfSatelites(orbits, planet)
    satelites = get(orbits,planet,[])
    
    num_of_satelites = 0
    for satelite in satelites
        num_of_satelites += getNumOfSatelites(orbits,satelite)+1
    end

    return num_of_satelites
end

function stepsToSanta(orbits,planet)
    tot_steps = 0
    satelites = get(orbits,planet,[])
    if satelites == []
        return false,0
    elseif "SAN" in satelites
        return true,tot_steps
    else
        tot_steps += 1
        for satelite in satelites
            (found,steps) = stepsToSanta(orbits,satelite)
            if found
                return found,tot_steps+steps
            end
        end
    end
    return false,0
end

function getDistanceToSanta(orbits, stars)
    current_planet = stars["YOU"]

    tot_steps = 0
    while true
        (found,steps) = stepsToSanta(orbits, current_planet)
        if found
            tot_steps += steps
            break
        end
        current_planet = stars[current_planet]
        tot_steps+=1
    end
    return tot_steps
end

function getOrbits(lines)
    orbits = Dict{String, Any}()
    stars = Dict{String,String}()
    for line in lines
        m = match(r"(.*)\)(.*)",line)
        planet = m[1]        
        satelite = m[2]

        satelites = get(orbits,planet,String[])
        push!(satelites,satelite)
        orbits[planet] = satelites
        stars[satelite] = planet
    end
    return orbits,stars
end

function part2(lines)
    (orbits,stars) = getOrbits(lines)
    
    return getDistanceToSanta(orbits, stars)
end


using Test

@test part2(["B)YOU","B)SAN"]) == 0
@test part2(["A)YOU","A)B","B)SAN"]) == 1
@test part2(["A)C", "C)YOU","A)B","B)SAN"]) == 2

open("input.txt") do f
    println(part2(readlines(f)))
end