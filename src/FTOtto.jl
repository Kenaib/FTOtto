module FTOtto

###Bibliotecas
using IdealGasLib
using Plots
using DataFrames
using PrettyTables

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

end
