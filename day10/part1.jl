function getAsteroids(input)
    width = [k for k in eachmatch(r"\n",a)][1].offset
    asteroids = [[(m.offset-1)%width,floor(Int,(m.offset-1)/width)] for m in eachmatch(r"#", a)]
    distances = Dict()
    for asteroid in asteroids
        distances[asteroid] = [asteroid_other - asteroid for asteroid_other in asteroids if asteroid_other != asteroid]
    end
    return distances
end

function getNonObscuredAsteroids(distances)
    angles_los = Dict()
    for (key,value) in distances
        angles = [(360+atan(-e[2],e[1])*180/pi)%360 for e in value]
        angles_los[key] = unique(angles)
    end
    return angles_los
end

a = ".#..#
.....
#####
....#
...##"

distances = getAsteroids(a)
nonObscuredAsteroids = getNonObscuredAsteroids(distances)
maximum(map(length,values(nonObscuredAsteroids)))