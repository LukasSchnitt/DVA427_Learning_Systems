using LinearAlgebra, DelimitedFiles

#Class for the Iris-Dataset
# 1 = Setosa
# 2 = Versicolor
# 3 = Virginica

translater_to_class = Dict([("setosa", 1), ("versicolor", 2), ("virginica", 3)])
translater_to_name = Dict([(1, "setosa"), (2, "versicolor"), (3, "virginica")])

function normalization(data)
    # Normalization Xnorm = X - Xmin / Xmax - xmin
    for i = 1:size(data)[2]-1
        max_value = maximum(data[:,i])
        min_value = minimum(data[:,i])
        x_diff = max_value - min_value

        for j = 1:size(data)[1]
            data[j,i] = (data[j,i]-min_value) / x_diff
        end
    end
    return data
end


function membership_short(x)
    return (1/-0.6)*x + 1
end

function membership_medium(x)
    if x >= 0.6
        return (-1/0.4)*x + 2.5
    elseif x < 0.6
        return (1/0.6)*x
    end
end

function membership_long(x)
    return (1/0.4)*x - 1.5
end

function fuzzy_classifier(data)
    decision = ["","","",""]
    for i = 1:4
        membership = [0.,0.,0.]
        membership[1] = membership_short(data[i])
        membership[2] = membership_medium(data[i])
        membership[3] = membership_long(data[i])
        if maximum(membership) == membership[1]
            decision[i] = "short"
        elseif maximum(membership) == membership[2]
            decision[i] = "medium"
        elseif maximum(membership) == membership[3]
            decision[i] = "long"
        end
    end
    if ((decision[1] == "short" || decision[1] == "long") &&
        (decision[2] == "medium" || decision[2] == "long") &&
        (decision[3] == "medium" || decision[3] == "long") &&
        (decision[4] == "medium"))
        return "versicolor"
    elseif ((decision[3] == "short" || decision[3] == "medium") &&
            (decision[4] == "short"))
            return "setosa"
    elseif ((decision[2] == "short" || decision[2] == "medium") &&
            (decision[3] == "long") && (decision[4] == "long"))
            return "virginica"
    elseif ((decision[1] == "medium") &&
            (decision[2] == "short" || decision[2] == "medium") &&
            (decision[3] == "short") && (decision[4] == "long"))
            return "versicolor"
    end
end

function test_accuracy(data)
    abs_accuracy = 0
    for i = 1:150
        prediction = fuzzy_classifier(data[i,:])
        if prediction == translater_to_name[trunc(Int,data[i,5])]
            abs_accuracy = abs_accuracy + 1
        end
    end
    return (abs_accuracy/150) * 100
end


data = readdlm("iris.txt", Float16)
#print(size(data))
norm_data = normalization(copy(data))
#print(norm_data)
#println(fuzzy_classifier(norm_data[101,:]))
#println(translater_to_name[trunc(Int,norm_data[101,5])])
accuracy = test_accuracy(norm_data)
println("Accuracy of Fuzzy-Classifier is ", accuracy, " %")
