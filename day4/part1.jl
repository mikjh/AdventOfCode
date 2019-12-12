function undigit(d; base=10)::Int
    s = zero(eltype(d))
    mult = one(eltype(d))*base^(length(d)-1)
    for val in d
        s += val * mult
        mult /= base
    end
    return s
end

using Test
@test undigit([3,4]) == 34
@test undigit([3,4,5,6]) == 3456

function next_valid(value)::Int
    value += 1
    value_digits = reverse(digits(value))
    lowest_possible_num = 0
    prev_value = 0
    value_at = 1
    change_values = false
    for (i,digit) in enumerate(value_digits)
        if change_values
            value_digits[i] = lowest_possible_num
        else
            if prev_value > digit
                lowest_possible_num = prev_value
                change_values = true
                value_digits[i] = lowest_possible_num
            end 
        end
        prev_value = digit
    end

    return undigit(value_digits)
end

using Test
#successfull
@test next_valid(11) == 12
@test next_valid(111) == 112

@test next_valid(20) == 22
@test next_valid(320) == 333
@test next_valid(245182) == 245555
@test next_valid(299999) == 333333

function isolated_zero(input)
    
end

function remove_non_doubles(input)
    input_list = map(x->reverse(digits(x)),input)
    filter!(l -> 0 in diff(l),input_list)
    return map(undigit,input_list)
end



function number_of_codes(lower_bound, upper_bound)
    value = lower_bound
    it = -1
    digits = Int[]
    while value < upper_bound
        it += 1
        value = next_valid(value)
        push!(digits, value)
    end

    removed_digits = remove_non_doubles(digits)
    
    for removed_digit in removed_digits
        println(removed_digit)
    end

    return length(removed_digits)
end

@test number_of_codes(20,22) == 1
@test number_of_codes(245182,245555) == 1
@test number_of_codes(245182,245556) == 2

println(number_of_codes(245182,790572))

@test remove_non_doubles([12,11]) == [11]