using Printf
using Combinatorics

function Intcode(input1,input2,comma_separated_list)
    list_to_process = map(x->parse(Int64,x),split(comma_separated_list,','))

    op_index = 1;

    output = Int[]

    first = true
    while true
        op_with_args = list_to_process[op_index]

        if op_with_args == 99
            break;
        end

        op_digits = digits(op_with_args)

        op = zeros(Int,1,2)
        if length(op_digits) > 1
            op = op_digits[1:2]
        else
            op[1] = op_digits[1]
        end
        args = zeros(Int,3,1)
        if length(op_digits) > 2
            args[1:length(op_digits[3:end])] = op_digits[3:end]
        end

        if op[1] == 3
            ind1 = list_to_process[op_index+1]+1

            list_to_process[ind1] = first ? input1 : input2
            first = false
            op_index+=2
            continue
        end

        if op[1] == 4
            ind1 = list_to_process[op_index+1]+1
            el1 = 0
            if args[1] == 0
                el1 = list_to_process[ind1]
            elseif args[1] == 1
                el1 = list_to_process[op_index+1]
            end
            push!(output,el1)
            op_index+=2
            continue
        end

        ind1 = list_to_process[op_index+1]+1
        el1 = 0
        if args[1] == 0
            el1 = list_to_process[ind1]
        elseif args[1] == 1
            el1 = list_to_process[op_index+1]
        end

        ind2 = list_to_process[op_index+2]+1
        el2 = 0
        if args[2] == 0
            el2 = list_to_process[ind2]
        elseif args[2] == 1
            el2 = list_to_process[op_index+2]
        end

        if op[1] == 1
            ind3 = list_to_process[op_index+3]+1
            list_to_process[ind3] = el1 + el2
            op_index+=4
        elseif op[1] == 2
            ind3 = list_to_process[op_index+3]+1
            list_to_process[ind3] = el1 * el2
            op_index+=4
        elseif op[1] == 5
            if el1 != 0
                op_index = el2+1
            else
                op_index += 3
            end
        elseif op[1] == 6
            if el1 == 0
                op_index = el2+1
            else
                op_index += 3
            end
        elseif op[1] == 7
            ind3 = list_to_process[op_index+3]+1
            if el1 < el2
                list_to_process[ind3] = 1
            else
                list_to_process[ind3] = 0
            end
            op_index+=4
        elseif op[1] == 8
            ind3 = list_to_process[op_index+3]+1
            if el1 == el2
                list_to_process[ind3] = 1
            else
                list_to_process[ind3] = 0
            end
            op_index+=4
        end
    end

    return output[end]
end

function amplifiers(comma_separated_list)
    amplifiers = permutations(collect(0:4))

    max_output = 0
    max_amplifier = 0

    for amplifier in amplifiers
        output = 0
        for input in amplifier
            output = Intcode(input,output,comma_separated_list)
        end
        if output > max_output
            max_output = output
            max_amplifier = amplifier
        end
    end

    return max_output, max_amplifier
end

using Test
@test amplifiers("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0") == tuple(43210,[4,3,2,1,0])
@test amplifiers("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0") == tuple(54321,[0,1,2,3,4])
@test amplifiers("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0") == tuple(65210,[1,0,4,3,2])

println(amplifiers("3,8,1001,8,10,8,105,1,0,0,21,30,39,64,81,102,183,264,345,426,99999,3,9,1001,9,2,9,4,9,99,3,9,1002,9,4,9,4,9,99,3,9,1002,9,5,9,101,2,9,9,102,3,9,9,1001,9,2,9,1002,9,2,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,3,9,4,9,99,3,9,102,4,9,9,1001,9,3,9,102,4,9,9,1001,9,5,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,99"))



