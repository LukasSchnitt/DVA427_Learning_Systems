using LinearAlgebra, Distributions


inputnodes = 19
outputnodes = 2
hiddennodes = 100
learningrate = 0.1

weights_ih = rand(Uniform(-1/(hiddennodes^0.5), 1/(hiddennodes^0.5)),19,100)
weights_ho = rand(Uniform(-1/(outputnodes^0.5), 1/(outputnodes^0.5)),2,100)

function sigmoid(x)
    return 1/(1+exp(-x))
end

function sigmoid_derivation(x)
    return sigmoid(x)*(1-sigmoid(x))
end

function feed_forward(vector, weights_input, weights_output)
    input_mult = weights_input * vector
    input_mult = map(x -> sigmoid(x), input_mult)

    output = weights_output * input_mult
    output = map(x -> sigmoid(x), output)

    return output
end

function train(data, weights_input, weights_output)
    body
end
