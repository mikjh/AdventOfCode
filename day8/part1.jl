function part1(numbers,step)
    segs = [numbers[i:step+i-1] for i in 1:step:length(numbers)]
    zero_counts = map(seg->count(num->num=='0',seg),segs)
    (min_count,min_index) = findmin(zero_counts)
    return count(num->num=='1',segs[min_index]) * count(num->num=='2',segs[min_index])
end

using Test
@test part1("123456129012",6) == 1

open("input.txt") do f
    line = readline(f)
    println(part1(line,25*6))
end