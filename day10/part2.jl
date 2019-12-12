using LinearAlgebra

function getAsteroids(input)
    width = [k for k in eachmatch(r"\n",a)][1].offset
    asteroids = [[(m.offset-1)%width,floor(Int,(m.offset-1)/width)] for m in eachmatch(r"#", a)]
    distances = Dict()
    for asteroid in asteroids
        distances[asteroid] = [asteroid_other - asteroid for asteroid_other in asteroids if asteroid_other != asteroid]
    end
    return distances
end

function getBestAsteroid(distances)
    angles_los = Dict()
    best_position = [0,0]
    visible_asteroids_max = 0
    for (key,value) in distances
        angles = [(360+atan(-e[2],e[1])*180/pi)%360 for e in value]
        angles_los[key] = unique(angles)

        if length(angles_los[key]) > visible_asteroids_max
            visible_asteroids_max = length(angles_los[key])
            best_position = key
        end

    end

    return best_position,visible_asteroids_max
end

function getAngle(asteroid)
    return atan(-asteroid[2],asteroid[1])*180/pi
end

function fromRefAngle(angle)
    if angle > 90
        return (90 - angle) + 360
    else
        return 90 - angle
    end
end

function play(asteroids,asteroid_pos)

    angles = Dict(ang => [] for ang in unique([getAngle(asteroid) for asteroid in asteroids]))

    for asteroid in asteroids
        push!(angles[getAngle(asteroid)],norm(asteroid))
    end

    for (key,value) in angles
        sort!(angles[key], rev=true)
    end

    shot = 0
    #println(asteroids)
    while !isempty(angles)
        actual_angles = [key for key in keys(angles)]
        sorted_angles = sort(actual_angles, by=fromRefAngle)
        #println(sorted_angles)
        #println(angles)
        for angle_to_shoot in sorted_angles
            if isempty(angles[angle_to_shoot])
                delete!(angles,angle_to_shoot)
                continue
            end
            killed = pop!(angles[angle_to_shoot])
            shot += 1
            println()
            print("at iteration ")
            print(shot)
            print(" killed ")
            rel_pos_killed = [cos(pi*angle_to_shoot/180)*killed,-sin(pi*angle_to_shoot/180)*killed]
            abs_pos_killed = asteroid_pos + rel_pos_killed 
            print(abs_pos_killed)
        end
        
    end

    return shot
end

a = ".#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##"

distances = getAsteroids(a)
(asteroid_pos, max_visible_asteroids) = getBestAsteroid(distances)

angles = play(distances[asteroid_pos],asteroid_pos)