using LinearAlgebra, Distributions


inputnodes = 19
outputnodes = 2
hiddennodes = 100
learningrate = 0.1

#Outputnodes = First Node is Class 0, Second Node is Class 1

weights_ih = rand(Uniform(-1/(hiddennodes^0.5), 1/(hiddennodes^0.5)),19,100)
weights_ho = rand(Uniform(-1/(outputnodes^0.5), 1/(outputnodes^0.5)),2,100)

function sigmoid(x)
    return 1/(1+exp(-x))
end

function sigmoid_derivation(x)
    return sigmoid(x)*(1-sigmoid(x))
end

function loss(output, solution)
    loss_value = 0
    for x in zip(output, solution)
        loss_value = loss_value + (x[1] - x[2])^2
    end
    return 0.5*loss_value
end


function feed_forward(vector, weights_input, weights_output)
    hidden_input = weights_input * input
    hidden_out = map(x -> sigmoid(x), hidden_input)

    final_input = weights_output * hidden_out
    final_out = map(x -> sigmoid(x), final_input)

    return (hidden_out, final_out)
end

function train(data, weights_input, weights_output)
    for i in range 1:size(data)[1]
        (hidden_out, final_out) = feed_forward(data[i,:][1:19], weights_ih, weights_ho)
        if(data[i,20] == 0)
            target_output = [1,0]
        else
            target_output = [0,1]
        error_out = final_out - target_out
        delta_out = map(x -> sigmoid_derivation(x), final_out)*error_out

        weights_ho = weights_ho + (learningrate*delta_out*hidden_out)




end
