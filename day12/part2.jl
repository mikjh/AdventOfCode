using LinearAlgebra
using Printf

mutable struct Moon
    pos
    vel
end

function printMoon(moon)
    @printf("pos=<x= %d, y= %d, z= %d>, vel=<x= %d, y= %d, z= %d>\n",moon.pos[1],moon.pos[2],moon.pos[3],moon.vel[1],moon.vel[2],moon.vel[3])
end

function updateVel(moons)
    for moon in moons
        for other_moon in moons
            if moon == other_moon
                continue
            end
            distance = map(el->(el == 0 ? 0 : (el > 0 ? 1 : -1)), other_moon.pos - moon.pos)
            moon.vel += distance
        end
    end
end

function updatePos(moons)
    foreach(moon->moon.pos += moon.vel, moons)
end

function energy(moons)
    tot_energy = 0
    for moon in moons
        abs_pos = cumsum(map(abs,moon.pos))
        abs_vel = cumsum(map(abs,moon.vel))
        tot_energy += abs_pos[end]*abs_vel[end]
    end
    return tot_energy
end

function simulate(moons)
    
    for i = 1:3
        it = 0
        first_pos_d = [moon.pos[i] for moon in moons]
        moons_sim = deepcopy(moons)
        while true
            updateVel(moons_sim)
            updatePos(moons_sim)
            it += 1
            #@printf("step: %d\n", i)
            #foreach(printMoon, moons)
            if first_pos_d == [moon.pos[i] for moon in moons_sim]
                break
            end
        end
        println(it+1)
    end
end

function parse_input(input)
    moons = [Moon(map(x->parse(Int,x), m.captures),[0,0,0]) for m in eachmatch(r".*\<x=(-?\d+), y=(-?\d+), z=(-?\d+)\>",input)]
    return moons
end

moons = parse_input("<x=16, y=-8, z=13>
<x=4, y=10, z=10>
<x=17, y=-5, z=6>
<x=13, y=-3, z=0>")
simulate(moons)