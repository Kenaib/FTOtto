module FTOtto

###Bibliotecas
using IdealGasLib
using DrWatson
using Plots
using DataFrames
using PrettyTables

###Setup DrWatson.jl
initialize_project("FTOtto_Sim"; authors="GB", force = true)

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
