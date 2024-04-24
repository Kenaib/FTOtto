module FTOtto

###Bibliotecas
using IdealGasLib
using DrWatson
using Plots
using DataFrames
using PrettyTables

###Setup DrWatson.jl
initialize_project("FTOtto_SIMULATION"; authors="GB", force = true)

function SAVE_SIM(;Init_Data::Dict, Results::Dict, Name = nothing)
    wsave(datadir("SIMULATION_INITIAL_DATA", savename(Name, "jld2")), Init_Data)
    wsave(datadir("SIMULATION_RESULTS", savename("R_", Name, "jld2")), Results)
end
###Função de dados iniciais 

include("InitialData_function.jl")

###Funções auxiliares primárias

include("PrimaryFunctions.jl")

###Função de inicialização

include("Initialization.jl")

###Funções auxiliares secundárias

include("Function_chem_time.jl")
include("SecondaryFunctions.jl")

###Tupla de tolerâncias

ϵ = (eps(1.0), eps(1.0), eps(1.0))

###FTHA 

include("FTHA.jl")

###cFTAS-iK

include("cFTAS-iK.jl")

###cFTAF-iK

include("cFTAF-iK.jl")

#Algoritmo de finalização

include("FinalAlg.jl")

###Testes

include("CodeTests.jl")
include("Teste_chem_time.jl")

end
