using Printf

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

function newDirection(direction, output)
    if output == 1
        direction += 1
    elseif output == 0
        direction -= 1
    end

    if direction < 0
        direction = 3
    elseif direction > 3
        direction = 0
    end

    return direction
end

function newPosition(position, direction)

    if direction == 0
        position += [0,1]
    elseif direction == 1
        position += [1,0]
    elseif direction == 2
        position += [0,-1]
    elseif direction == 3
        position += [-1,0]
    end

    return position
end

function simulate(comma_separated_list)
    current_position = [0,0]
    direction = 0
    plates = Dict()

    int_code = makeAmp(comma_separated_list)

    halted = false
    while !halted
        input = current_position in keys(plates) ? (plates[current_position] == "w" ? 1 : 0) : 0
        halted = intcode(int_code,input)
        if halted
            break
        end
        plates[current_position]  = int_code.output == 1 ? "w" : "b"
        halted = intcode(int_code,input)
        if halted
            break
        end
        direction = newDirection(direction,int_code.output)
        println("")
        print("Input: ")
        print(input)
        print(" position: ")
        print(current_position)
        current_position = newPosition(current_position,direction)
        print(" new position: ")
        print(current_position)
        print(" direction: ")
        print(direction)
        print(" output: ")
        print(int_code.output)
    end

    return plates
end


plates = simulate("3,8,1005,8,299,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,29,1,1007,14,10,2,1106,8,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,58,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,1002,8,1,80,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,103,1,5,6,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,101,0,8,128,1,106,18,10,1,7,20,10,1006,0,72,1006,0,31,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,164,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,102,1,8,186,1,1007,8,10,1006,0,98,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,216,2,102,8,10,1,1008,18,10,1,1108,8,10,1006,0,68,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,1001,8,0,253,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,274,1,1105,7,10,101,1,9,9,1007,9,1060,10,1005,10,15,99,109,621,104,0,104,1,21102,936995738520,1,1,21102,316,1,0,1106,0,420,21101,0,936995824276,1,21102,1,327,0,1106,0,420,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,248129784923,1,1,21102,1,374,0,1105,1,420,21102,29015149735,1,1,21101,385,0,0,1106,0,420,3,10,104,0,104,0,3,10,104,0,104,0,21101,983925826304,0,1,21101,0,408,0,1105,1,420,21102,825012036364,1,1,21101,0,419,0,1105,1,420,99,109,2,22101,0,-1,1,21101,0,40,2,21101,0,451,3,21102,441,1,0,1105,1,484,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,446,447,462,4,0,1001,446,1,446,108,4,446,10,1006,10,478,1101,0,0,446,109,-2,2105,1,0,0,109,4,2102,1,-1,483,1207,-3,0,10,1006,10,501,21102,0,1,-3,21201,-3,0,1,22102,1,-2,2,21102,1,1,3,21101,520,0,0,1106,0,525,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,548,2207,-4,-2,10,1006,10,548,21201,-4,0,-4,1105,1,616,21201,-4,0,1,21201,-3,-1,2,21202,-2,2,3,21102,1,567,0,1105,1,525,21202,1,1,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,586,21102,0,1,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,608,21201,-1,0,1,21102,1,608,0,106,0,483,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0")

