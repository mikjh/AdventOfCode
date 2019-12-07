function process(comma_separated_list)
    list_to_process = map(x->parse(Int64,x),split(comma_separated_list,','))

    op_index = 1;

    while true
        op = list_to_process[op_index]

        if op == 99
            break;
        end

        ind1 = list_to_process[op_index+1]+1
        el1 = list_to_process[ind1]

        ind2 = list_to_process[op_index+2]+1
        el2 = list_to_process[ind2]

        ind3 = list_to_process[op_index+3]+1

        if op == 1
            list_to_process[ind3] = el1 + el2
        elseif op == 2
            list_to_process[ind3] = el1 * el2
        end

        op_index+=4
    end

    return list_to_process
end

using Test
@test process("1,1,2,3,99") == [1,1,2,3,99]
@test process("2,1,2,3,99") == [2,1,2,2,99]
@test process("1,1,2,3,99,2,6,7,8,99") == [1,1,2,3,99,2,6,7,8,99]
@test process("1,1,2,3,2,5,6,7,99") == [1,1,2,3,2,5,6,30,99]
@test process("1,0,0,0,99") == [2,0,0,0,99]
@test process("2,3,0,3,99") == [2,3,0,6,99]
@test process("2,4,4,5,99,0") == [2,4,4,5,99,9801]
@test process("1,1,1,4,99,5,6,0,99") == [30,1,1,4,2,5,6,0,99]

v = process("1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,10,19,23,1,6,23,27,1,5,27,31,1,10,31,35,2,10,35,39,1,39,5,43,2,43,6,47,2,9,47,51,1,51,5,55,1,5,55,59,2,10,59,63,1,5,63,67,1,67,10,71,2,6,71,75,2,6,75,79,1,5,79,83,2,6,83,87,2,13,87,91,1,91,6,95,2,13,95,99,1,99,5,103,2,103,10,107,1,9,107,111,1,111,6,115,1,115,2,119,1,119,10,0,99,2,14,0,0")
println("part1:")
print(v[1])
println("part2:")


input = [1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,10,19,23,1,6,23,27,1,5,27,31,1,10,31,35,2,10,35,39,1,39,5,43,2,43,6,47,2,9,47,51,1,51,5,55,1,5,55,59,2,10,59,63,1,5,63,67,1,67,10,71,2,6,71,75,2,6,75,79,1,5,79,83,2,6,83,87,2,13,87,91,1,91,6,95,2,13,95,99,1,99,5,103,2,103,10,107,1,9,107,111,1,111,6,115,1,115,2,119,1,119,10,0,99,2,14,0,0]
for verb = 0:99
    for noun = 0:99
        input[2] = noun
        input[3] = verb
        res = process(join(string.(input),","))
        if res[1] == 19690720
            println(100*noun + verb)
            break
        end
    end
end
