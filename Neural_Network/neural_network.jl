using LinearAlgebra, Distributions
include("FileInput.jl")

function sigmoid(x)
    return 1/(1+exp(-x))
end

function sigmoid_derivation(x)
    return sigmoid(x)*(1-sigmoid(x))
end

function relu(x)
    return max(0,x)
end

function relu_derivation(x)
    if x < 0
        return 0
    elseif x >= 0
        return 1
    end
end

function feed_forward(input, weights_input, weights_output)
    hidden_input = weights_input * input
    hidden_out = map(x -> relu(x), hidden_input)

    final_input = weights_output * hidden_out
    final_out = map(x -> sigmoid(x), final_input)

    return hidden_out, final_out
end

function train(data, weights_input, weights_output, alpha)
    for i = 1:size(data)[1]
        input = data[i,:][1:19]
        hidden_out, final_out = feed_forward(input, weights_input, weights_output)
        #if(data[i,:][20] == 1)
        #    target_out = [0, 1]
        #else
        #    target_out = [1, 0]
        #end
        target_out = [Int(data[i,20])]

        error_out = target_out - final_out
        error_hidden = transpose(weights_output)*error_out

        delta_out = error_out .* map(x -> sigmoid_derivation(x), final_out)
        weights_output = weights_output + learningrate*(delta_out*transpose(hidden_out))

        delta_hidden = error_hidden .* map(x -> relu_derivation(x), hidden_out)
        weights_input = weights_input + learningrate*(delta_hidden*transpose(input))

    end
    return weights_output, weights_input
end

function query(input, class, wih, who)
    hidden_out, final_out = feed_forward(input, wih, who)
    println("class is ", Int(class))
    println("Accuracy is ", final_out[1])
    #println("Accuracy for class 1 is ", final_out[2])
end

function predict_probability(input)
    hidden_out, final_out = feed_forward(input, nwhi, nwho)
    return final_out
end

inputnodes = 19
outputnodes = 1
hiddennodes = 75
learningrate = 0.01

#Outputnodes = First Node is Class 0, Second Node is Class 1

weights_ih = rand(Uniform(-1/(hiddennodes^0.5), 1/(hiddennodes^0.5)),hiddennodes,inputnodes)
weights_ho = rand(Uniform(-1/(outputnodes^0.5), 1/(outputnodes^0.5)),outputnodes,hiddennodes)

data = readdlm("Diabetic.txt", ',', Float32, '\n', skipstart = 24)
norm_data = normalization(copy(data))

nwhi =  weights_ih
nwho = weights_ho

for epochs = 1:5
    global nwho, nwhi = train(norm_data[1:865,:], nwhi, nwho, learningrate)
end

query(norm_data[1150,:][1:19], norm_data[1150,20], nwhi, nwho)
query(norm_data[1151,:][1:19], norm_data[1151,20], nwhi, nwho)
#println(predict_probability(norm_data[1150,:][1:19]))
