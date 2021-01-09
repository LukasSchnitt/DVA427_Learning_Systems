using DelimitedFiles

function create_cities(data)
    city_list = []
    for i=1:size(data)[1]
        tmp = Dict("id" => data[i,1], "x" => Int(parse(Float64,data[i,2])), "y" => Int(parse(Float64,data[i,3])))
        push!(city_list,tmp)
    end
    return city_list
end

function calculate_distance_between_two_points(point1, point2)
    return sqrt((((point2[1] - point1[1]))^2) + (((point2[2] - point1[2]))^2))
end

function calculate_chromosome_travel_distance(chromosome)
    travel_distance = 0
    chromosome = vcat(1, chromosome, 1)
    for geneId in 1:length(chromosome) - 1
        point1 = (
            cities[chromosome[geneId]]["x"],
            cities[chromosome[geneId]]["y"]
            )
        point2 = (
            cities[chromosome[geneId + 1]]["x"],
            cities[chromosome[geneId + 1]]["y"]
            )
        travel_distance += calculate_distance_between_two_points(point1, point2)
    end
    return travel_distance
end


function crossover(parent_one_chromosome, parent_two_chromosome, crossover_point)
    offspring_part_one = parent_one_chromosome[1:crossover_point]
    for gene in offspring_part_one
        if gene in parent_two_chromosome
            gene_loc = findfirst(el -> el == gene, parent_two_chromosome)
            splice!(parent_two_chromosome, gene_loc)
        end
    end
    return vcat(offspring_part_one, parent_two_chromosome)
end

function mutate(offspring)
    random_mutation_point1 = rand(1:length(offspring))
    random_mutation_point2 = rand(1:length(offspring))
    if mutation_method == 1
        offspring[random_mutation_point1], offspring[random_mutation_point2] = offspring[random_mutation_point2], offspring[random_mutation_point1]
    elseif mutation_method == 2
        offspring[random_mutation_point1:random_mutation_point2] = reverse(offspring[random_mutation_point1:random_mutation_point2])
    end
    return offspring
end

function shuffle_chromosome(chromosome)
    for i in 1:size(chromosome)[1]
        random_point = rand(1:5, 1)[1]
        chromosome[i], chromosome[random_point] = chromosome[random_point], chromosome[i]
    end
    return chromosome
end


function generate_initial_population(initial_population_size)
    chromosomes = []
    for population_counter in 1:initial_population_size
        chromosome = shuffle_chromosome(copy(initial_chromosome))
        push!(chromosomes,
            Dict(
                "chromosome" => chromosome,
                "distance" => calculate_chromosome_travel_distance(chromosome)
            )
        )
    end
    return chromosomes
end

function genetic_algorithm(generation_count, offsprings_count, crossover_point)
    for generation in 1:generation_count

        for offspring_count in 1:offsprings_count
            #println("generation: ", generation, " offspring: ", offspring_count)
            #sort!(chromosomes, by=x -> x["distance"], rev=false)
            #random_parent_one_id = rand(1:size(chromosomes)[1])
            #random_parent_two_id = rand(1:size(chromosomes)[1])
            random_parent_one_id = rand(1:5)
            random_parent_two_id = rand(1:5)
            random_parent_one = copy(chromosomes[random_parent_one_id]["chromosome"])
            random_parent_two = copy(chromosomes[random_parent_two_id]["chromosome"])
            offspring = crossover(random_parent_one, random_parent_two, crossover_point)
            offspring = mutate(offspring)
            push!(chromosomes,
                Dict(
                    "chromosome" => offspring,
                    "distance" => calculate_chromosome_travel_distance(offspring)
                    )
            )
        end
        sort!(chromosomes, by=x -> x["distance"], rev=false)
        splice!(chromosomes, 11:size(chromosomes)[1])
    end
end

# read data
data = readdlm("Labs/DVA427_Learning_Systems/Genetic_Algorithm/berlin52.tsp", String, skipstart=6)

cities = create_cities(data)
initial_chromosome = [2:length(cities);]
# generating 10 initial chromosomes
chromosomes = generate_initial_population(2000)
# 1: Reciprocal exchange mutation. 2: Inversion mutation.
# https://stackoverflow.com/questions/12412909/applying-mutation-in-a-ga-to-solve-the-traveling-salesman

mutation_method = 2
crossover_point = 8
generations = 100
offspring =600

genetic_algorithm(generations, offspring, crossover_point)
println("Optimal route:", vcat(1, chromosomes[1]["chromosome"], 1))
println("travel_distance:", chromosomes[1]["distance"])
