using Printf
using Combinatorics
using Revise

mutable struct Amp
    list_to_process::Vector{Int}
    op_index::Int
    output::Int
    first::Bool
end

function makeAmp(comma_separated_list)::Amp
    list_to_process = map(x->parse(Int64,x),split(comma_separated_list,','))
    return Amp(list_to_process[:], 1, -1,true)
end

function run(amp::Amp,input1,input2)
    while true
        op_with_args = amp.list_to_process[amp.op_index]

        if op_with_args == 99
            return true
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
            ind1 = amp.list_to_process[amp.op_index+1]+1

            amp.list_to_process[ind1] = amp.first ? input1 : input2
            amp.first = false
            amp.op_index+=2
            continue
        end

        if op[1] == 4
            ind1 = amp.list_to_process[amp.op_index+1]+1
            el1 = 0
            if args[1] == 0
                el1 = amp.list_to_process[ind1]
            elseif args[1] == 1
                el1 = amp.list_to_process[amp.op_index+1]
            end
            amp.op_index+=2
            amp.output=el1
            return false
        end

        ind1 = amp.list_to_process[amp.op_index+1]+1
        el1 = 0
        if args[1] == 0
            el1 = amp.list_to_process[ind1]
        elseif args[1] == 1
            el1 = amp.list_to_process[amp.op_index+1]
        end

        ind2 = amp.list_to_process[amp.op_index+2]+1
        el2 = 0
        if args[2] == 0
            el2 = amp.list_to_process[ind2]
        elseif args[2] == 1
            el2 = amp.list_to_process[amp.op_index+2]
        end

        if op[1] == 1
            ind3 = amp.list_to_process[amp.op_index+3]+1
            amp.list_to_process[ind3] = el1 + el2
            amp.op_index+=4
        elseif op[1] == 2
            ind3 = amp.list_to_process[amp.op_index+3]+1
            amp.list_to_process[ind3] = el1 * el2
            amp.op_index+=4
        elseif op[1] == 5
            if el1 != 0
                amp.op_index = el2+1
            else
                amp.op_index += 3
            end
        elseif op[1] == 6
            if el1 == 0
                amp.op_index = el2+1
            else
                amp.op_index += 3
            end
        elseif op[1] == 7
            ind3 = amp.list_to_process[amp.op_index+3]+1
            if el1 < el2
                amp.list_to_process[ind3] = 1
            else
                amp.list_to_process[ind3] = 0
            end
            amp.op_index+=4
        elseif op[1] == 8
            ind3 = amp.list_to_process[amp.op_index+3]+1
            if el1 == el2
                amp.list_to_process[ind3] = 1
            else
                amp.list_to_process[ind3] = 0
            end
            amp.op_index+=4
        end
    end
end

function amplifiers(comma_separated_list)
    amplifiers = permutations(collect(5:9))

    max_output = 0
    max_amplifier = 0

    for amplifier in amplifiers
        output = 0
        index = 0
        amplifier_opindex = Dict{Int,Amp}(i => makeAmp(comma_separated_list) for i in 1:5)

        halted = false
        while !halted
            input = amplifier[index+1]
            halted_amp = run(amplifier_opindex[index+1],input,output)
            if halted_amp
                break
            end

            output = amplifier_opindex[index+1].output

            index += 1
            index %= 5
        end

        if output > max_output
            max_output = output
            max_amplifier = amplifier
        end
    end

    return max_output, max_amplifier
end

using Test
#@test amplifiers("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5") == tuple(139629729,[9,8,7,6,5])

#@test amplifiers("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10") == tuple(18216, [9,7,8,5,6])
#@test amplifiers("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0") == tuple(54321,[0,1,2,3,4])
#@test amplifiers("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0") == tuple(65210,[1,0,4,3,2])
#
println(amplifiers("3,8,1001,8,10,8,105,1,0,0,21,30,39,64,81,102,183,264,345,426,99999,3,9,1001,9,2,9,4,9,99,3,9,1002,9,4,9,4,9,99,3,9,1002,9,5,9,101,2,9,9,102,3,9,9,1001,9,2,9,1002,9,2,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,3,9,4,9,99,3,9,102,4,9,9,1001,9,3,9,102,4,9,9,1001,9,5,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,99"))
