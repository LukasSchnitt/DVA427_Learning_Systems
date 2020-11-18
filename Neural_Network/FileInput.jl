using LinearAlgebra, DelimitedFiles



function normalization(data)
    # Normalization Xnorm = X - Xmin / Xmax - xmin
    for i in 1:size(data)[2]-1
        max_value = maximum(data[:,i])
        min_value = minimum(data[:,i])
        x_diff = max_value - min_value

        for j in 1:size(data)[1]
            data[j,i] = (data[j,i]-min_value) / x_diff
        end
    end
    return data
end

data = readdlm("Diabetic.txt", ',', Float32, '\n', skipstart = 24)
norm_data = normalization(copy(data))
