function get_message(numbers,width,height)
    step = width*height
    segs = map(num->[parse(Int,dig) for dig in num],[numbers[i:step+i-1] for i in 1:step:length(numbers)])
    
    acc_seg = [2 for i in 1:step]
    for seg in segs
        for i in 1:step
            acc_seg[i] = (acc_seg[i] == 2) ? seg[i] : acc_seg[i]
        end
    end
    #println(acc_seg)
    msg_lines = reshape(acc_seg,width,height)

    for i in 1:width
        println(join(map(num->string(num),msg_lines[i,:])))
    end
end

using Test
#get_message("0222112222120000",2,2)

function part2()
    open("input.txt") do f
        line = readline(f)
        get_message(line,25,6)
    end
end

part2()