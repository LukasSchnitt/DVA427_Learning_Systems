using LinearAlgebra, Distributions
include("FileInput.jl")

inputnodes = 19
outputnodes = 2
hiddennodes = 100
learningrate = 0.1

#Outputnodes = First Node is Class 0, Second Node is Class 1

weights_ih = rand(Uniform(-1/(hiddennodes^0.5), 1/(hiddennodes^0.5)),hiddennodes,inputnodes)
weights_ho = rand(Uniform(-1/(outputnodes^0.5), 1/(outputnodes^0.5)),outputnodes,hiddennodes)

function sigmoid(x)
    return 1/(1+exp(-x))
end

function sigmoid_derivation(x)
    return sigmoid(x)*(1-sigmoid(x))
end


function feed_forward(input, weights_input, weights_output)
    hidden_input = weights_input * input
    hidden_out = map(x -> sigmoid(x), hidden_input)

    final_input = weights_output * hidden_out
    final_out = map(x -> sigmoid(x), final_input)

    return hidden_out, final_out
end

function train(data, weights_input, weights_output, alpha)
    for i = 1:size(data)[1]
        input = data[i,:][1:19]
        hidden_out, final_out = feed_forward(input, weights_input, weights_output)
        if(data[i,20] == 0)
            target_out = [1,0]
        else
            target_out = [0,1]
        end
        error_out = target_out - final_out
        delta_out = map(x -> sigmoid_derivation(x), final_out).*error_out

        weights_output = weights_output + (-alpha*(delta_out*transpose(hidden_out)))

        error_hidden = reshape(delta_out'weights_output,100,1)
        delta_hidden = map(x -> sigmoid_derivation(x), hidden_out).*error_hidden

        weights_input = weights_input + (-learningrate*(delta_hidden*transpose(input)))
    end
    return weights_output, weights_input
end

function query(input, class, wih, who)
    hidden_out, final_out = feed_forward(input, wih, who)
    print("class is 0\n")
    print("Accurancy for class 0 is ", final_out[1])
    print("Accurancy for class 1 is ", final_out[2])
end

data = readdlm("Diabetic.txt", ',', Float32, '\n', skipstart = 24)
norm_data = normalization(copy(data))

query(norm_data[1,:], norm_data[1,20], weights_ih, weights_ho)

nwho, nwhi = train(norm_data, weights_ih, weights_ho, learningrate)

query(norm_data[1,:], norm_data[1,20], nwhi, nwho)
