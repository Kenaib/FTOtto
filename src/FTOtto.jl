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
    safesave(datadir("SIMULATION_INITIAL_DATA", savename(Name, "jld2")), Init_Data)
    safesave(datadir("SIMULATION_RESULTS", savename("R_", Name, "jld2")), Results)
end

function SAVE_PLOTS(;Plot_name::AbstractString, Plot)
    safesave(plotsdir("FTOtto_Plots", Plot_name*".png"), Plot)
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

###cFTAS-aK

include("cFTAS-aK.jl")

###cFTAF-iK

include("cFTAF-iK.jl")

###cFTAF-aK

include("cFTAF-aK.jl")

#Algoritmo de finalização

include("FinalAlg.jl")

###Testes

include("CodeTests.jl")
include("Teste_chem_time.jl")
include("Teste_chem_time_aK.jl")

end
