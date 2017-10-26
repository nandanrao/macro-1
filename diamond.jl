using Base.Test

shocked(low, high, p::Float64) = () -> rand() > p ? low : high

# to create a list of lists with values, pass function to call for each value, or const value
function generate_values(fns, n)
    c(f::Function) = f()
    c(v::Number)= v
    [[c(f) for f in fns] for i in 1:n]
end

@test generate_values([1,2], 2) == [[1,2], [1,2]]
@test generate_values([1,() -> 2], 2) == [[1,2], [1,2]]


# Plots law of motion over time with 45 degree line
# loms = list of tuples: (fn, params)
# TODO: label lines on graph
function plot_lom(loms, T = 10)
    fns = vcat([x -> x], [k -> lom(k,p...) for (lom,p) in loms])
    plot(fns, 0, T)    
end

function simulate(k, mapper, n = 0, lim = 1000)
    if n > lim
        return k
    end
    return simulate(mapper(k), mapper, n+1, lim)
end

# LAWS OF MOTION
function is_inefficient(k,A,a,n)
    df = A*a*k^(a-1) 
    df < 1+n, df, 1+n
end

# how to test for dynamic inefficiency?
function basic_diamond(k, n, B, a, A)
    if is_inefficient(k,A,a,n)[1]
        print("inefficient")
    end
    1/(1+n) * B/(1+B) * (1-a) * A * k^a
end

# dynamically inefficient at equilibrium! 
plot_lom([(basic_diamond, [.10,.8,.2,2])], .6)

# TODO: function for this...


