using LinearAlgebra, DelimitedFiles



function return_edges(data)
    list = []
    for i = 1:size(data)[1]
        tmp = edge(data[i,1], data[i,2], parse(Int,data[i,3]))
        push!(list,tmp)
    end
    return list
end

struct edge
    source::String
    destination::String
    distance::Int32
end

function describe(e::edge)::Nothing
    output = "From " * e.source * " to " * e.destination * " with cost of " * string(e.distance)
    print(output)
end

function dijkstra(edges)
    visited = Dict{edge, Bool}()
    for i = 1:size(edges)[1]
        visited[edges[i]] = false
    end

end

data = readdlm("Labs/DVA427_Learning_Systems/Dynamic_Programming/city 1.txt", String, skipstart=2)
edges = return_edges(data)
di = dijkstra(edges)
print(di)
#test = edge("A", "B", 10)
#describe(test)
