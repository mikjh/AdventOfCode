using LinearAlgebra
using Printf

function stretch(input,repeat_count)
    input_copy = deepcopy(input)
    j = 1
    for i in 1:length(input)
        input_copy[i] = input[j]
        if (i % repeat_count == 0)
            j += 1
        end
    end
    return input_copy
end

function create_pattern(size_of_pattern)
    pattern = repeat([1 0 -1 0], 1,ceil(Int,size_of_pattern/4))
    return pattern[1:end-size_of_pattern%4]
end

function create_patterns(size_of_pattern)
    base_pattern = create_pattern(size_of_pattern)

    patterns = zeros(Int, size_of_pattern,size_of_pattern)
    for i in 1:size_of_pattern
        pattern = stretch(base_pattern,i)
        patterns[i,:] = pattern
        #println(patterns)
        println(patterns[i,:])
        if i > 1
            for j in 1:i-1
                patterns[i,j] = 0
            end
        end
        println(patterns[i,:])
    end

    return patterns
end

function day1(input)
    input_digits = reverse(digits(input))
    input_length = length(input_digits)
    pattern = create_pattern(input_length)
    for phases = 1:1
        inner_pattern = deepcopy(pattern)

        result = zeros(size(pattern))
        for i = 1:input_length
            value = dot(input_digits, inner_pattern)
            result[i] = value % 10
            inner_pattern = shift_pattern(inner_pattern)
        end
        input_digits = deepcopy(result)
        println(result)
    end

    return
end
day1(12345678)

