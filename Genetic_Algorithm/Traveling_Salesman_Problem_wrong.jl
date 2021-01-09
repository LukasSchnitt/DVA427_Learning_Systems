using LinearAlgebra, DelimitedFiles, Random, StatsBase


function distance(city1,city2)
    return sqrt((city1[2] - city2[2])^2 + (city1[3] - city2[3])^2)
end

function create_cities(data)
    city_list = []
    for i=1:size(data)[1]
        tmp = tuple(data[i,1],Int(parse(Float64,data[i,2])),Int(parse(Float64,data[i,3])))
        push!(city_list,tmp)
    end
    return city_list
end

function create_population(cities, pop_size, start_city)
    population = []
    filter!(x->x≠start_city,cities)
    i = 0
    while i < pop_size
        tmp = copy(cities)
        tmp = shuffle(tmp)
        pushfirst!(tmp, start_city)
        push!(tmp, start_city)
        if tmp ∈ population
            continue
        end
        push!(population, tmp)
        i = i+1
    end
    return population
end

function compute_distance(chromosome)
    total_dist = 0
    for i=1:size(chromosome)[1]-1
        total_dist = total_dist + distance(chromosome[i],chromosome[i+1])
    end
    total_dist = total_dist + distance(chromosome[1],chromosome[size(chromosome)[1]])
    return total_dist
end

function create_distances(population)
    distances = Dict()
    for i=1:size(population)[1]
        distances[population[i]] = compute_distance(population[i])
    end
    return sort(distances, byvalue=true)
end


function create_fitness(population)
    fitness = Dict()
    for i=1:size(population)[1]
        fitness[population[i]] = compute_distance(population[i])
    end
    return fitness
end

function choose_parents(fitness, num_parents)
#=    total = sum(values(fitness))
    fitness_probability = copy(fitness)
    parents = []
    for path in keys(fitness)
        fitness_probability[path] = fitness[path]/total
    end
    paths = collect(keys(fitness_probability))
    weight = collect(values(fitness_probability))
    weight = convert(Array{Float64},weight)
    for i=1:num_parents
        tmp = sample(paths, weights(weight))
        while tmp ∈ parents
            tmp = sample(paths, weights(weight))
        end
        push!(parents,tmp)
    end =#
    parents = []
    fitness_sort = sort(copy(fitness), byvalue=true)
    key_list = collect(keys(fitness_sort))
    for i=1:num_parents
        push!(parents, key_list[i])
    end
    return parents
end

function get_mutant(chromosome)
    index1 = rand((2:size(chromosome)[1]-1))
    index2 = rand((2:size(chromosome)[1]-1))
    while index2 <= index1
        index2 = rand((2:size(chromosome)[1]))
    end
    mutation = chromosome[index1:index2]
    chromosome[index1:index2] = reverse(mutation)
    return chromosome
end

function inversion_mutation(parents)
    mutants = []
    for chromosome in parents
        proba = 0.5
        rand_num = rand()
        if rand_num <= proba
            mutation = get_mutant(copy(chromosome))
            while mutation ∈ parents
                mutation = get_mutant(copy(chromosome))
            end
        end
        mutation = copy(chromosome)
        push!(mutants,mutation)
    end
    return mutants
end

function recombine(parents, mutants)
    recombine = []
    proba = 0.5
    for i=1:size(parents)[1]
        rand_num = rand()
        if rand_num <= 0.5
            push!(recombine,mutants[i])
            continue
        end
        push!(recombine,parents[i])
    end
    return recombine
end

function actualize(old, new)
    new_pop = []
    for i=1:size(old)[1]
        if compute_distance(old[i]) <= compute_distance(new[i])
            push!(new_pop, old[i])
        else
            push!(new_pop, new[i])
        end
    end
    return new_pop
end

function genetic_algorithm(city_list, population_size, generations)
    population = create_population(city_list, population_size, city_list[1])
    fitness = create_fitness(population)
    for i=1:generations
        fitness = create_fitness(population)
        parents = choose_parents(fitness, Int(population_size/2))
        mutations = inversion_mutation(parents)
        population = actualize(parents, mutations)
    end
    return population, create_distances(population)
end

data = readdlm("Labs/DVA427_Learning_Systems/Genetic_Algorithm/berlin52.tsp", String, skipstart=6)
city_list = create_cities(data)
pop, pop_dist = genetic_algorithm(city_list, 1000, 200)
