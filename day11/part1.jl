using Printf
using Combinatorics
using Revise

mutable struct Amp
    list_to_process::Vector{Int128}
    op_index::Int
    output::Int
    first::Bool
    relative_offset::Int
    extra_mem::Dict{Int,Int128}
end

function get(amp,index)
    if index <= length(amp.list_to_process)
        return amp.list_to_process[index]
    end

    if index in keys(amp.extra_mem)
        return amp.extra_mem[index]
    end

    amp.extra_mem[index] = 0
    return 0
end

function set(amp,index,value)
    if index <= length(amp.list_to_process)
        amp.list_to_process[index] = value
        return
    end

    amp.extra_mem[index] = value
end

function makeAmp(comma_separated_list)::Amp
    list_to_process = map(x->parse(Int128,x),split(comma_separated_list,','))
    return Amp(list_to_process[:], 1, -1,true,1,Dict{Int,Int128}())
end

function get_arg(amp,ind,arg,arg_nr)
    el1 = 0
    if arg == 0
        el1 = get(amp,ind)
    elseif arg == 1
        el1 = get(amp,amp.op_index+arg_nr)
    elseif arg == 2
        el1 = get(amp,amp.relative_offset + get(amp,amp.op_index+arg_nr))
    end
    return el1
end

function get_index(amp,arg,ind_nr)
    ind = 0
    if arg == 0
        ind = get(amp,amp.op_index+ind_nr)+1
    elseif arg == 1
        println("ERROR HERE")
    elseif arg == 2
        ind = amp.relative_offset + get(amp,amp.op_index+ind_nr)
    end

    return ind
end

function intcode(amp::Amp,input)
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
        #println("")
        #print("op: ")
        #print(op)
        #print(" args: ")
        #print(args)
        #print(" op_index: ")
        #print(amp.op_index)
        #print(" rel off: ")
        #print(amp.relative_offset)

        if op[1] == 3
            ind1 = 0
            ind1 = get_index(amp, args[1], 1);
            set(amp, ind1, input)
            amp.first = false
            amp.op_index+=2
            continue
        end

        if op[1] == 4
            ind1 = get(amp,amp.op_index+1)+1
            el1 = get_arg(amp,ind1,args[1],1)
            amp.op_index+=2
            amp.output=el1
            return false
        end

        ind1 = get(amp,amp.op_index+1)+1
        el1  = get_arg(amp,ind1,args[1],1)
        #print(" e1: ")
        #print(el1)

        if op[1] == 9
            amp.relative_offset += el1
            amp.op_index += 2
            continue
        end 

        ind2 = get(amp,amp.op_index+2)+1
        el2  = get_arg(amp,ind2,args[2],2)
        #print(" e2: ")
        #print(el2)

        if op[1] == 1
            ind3 = get_index(amp, args[3], 3);
            set(amp,ind3,el1+el2)
            amp.op_index+=4
        elseif op[1] == 2
            ind3 = get_index(amp, args[3], 3);
            set(amp,ind3,el1*el2)
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
            ind3 = get_index(amp, args[3], 3);
            if el1 < el2
                set(amp,ind3,1)
            else
                set(amp,ind3,0)
            end
            amp.op_index+=4
        elseif op[1] == 8
            ind3 = get_index(amp, args[3], 3);
            if el1 == el2
                set(amp,ind3,1)
            else
                set(amp,ind3,0)
            end
            amp.op_index+=4
        end
    end
end

function run(comma_separated_list)
    pos = [0,0]
    dir = [0,1]

    amp = makeAmp(comma_separated_list)

    white_pos = []
    halted = false
    while !halted
        if pos in white_pos
            halted = intcode(amp,1)
        else
            halted = intcode(amp,0)
        end
        if amp.output == 1
            push!(white_pos,pos)
            pos
        else
            return
        end
    end
end

function run_file()
    open("input.txt") do f
        line = readline(f)
        run(line)
    end
end

using Test

#run("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
#run("1102,34915192,34915192,7,4,7,99,0")
#run("104,1125899906842624,99")
run_file()
