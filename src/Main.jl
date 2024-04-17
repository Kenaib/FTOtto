module FTOtto

###Bibliotecas
using IdealGasLib
using DrWatson
using Plots
using DataFrames
using PrettyTables

###Setup DrWatson.jl
initialize_project("FTOtto_Sim"; authors="GB", force = true)

InitialData = Dict(
#Razão biela-manivela: 
    "r_LR" => 3.7,
#Razão de compressão: 
    "r_compr" => 12, 
#Volume deslocado:
    "Vol_des" => 1667e-6, 
#Número de cilindros:
    "n_cil" => 6, 
#Ângulo de ignição:
    "θ_ign" => deg2rad(-0.005),
#Tempo de combustão: (Temporário)
    "Δt_comb" => nothing,
#Rotação do motor: 
    "N_motor" => 2000,
#Razão diâmetro-curso: 
    "rD_S" => 1,
#Calor que entra no sistema: 
    "q_ent" => 1000, #kJ/kg
#Alpha mínimo: 
    "α_minimo" => deg2rad(-180),
#Alpha máximo: 
    "α_maximo" => deg2rad(180),
#Malha angular: 
    "α" => deg2rad(0.1),
#Proprieades do fluido de trabalho: 
    "Fluido" => "C4H10", 
    #Temperatura de admissão: 
    "Tadm" => 30, #°C
    #Pressão de admissão: 
    "Padm" => P_()().val, #101.35 kPa
    #Reação: nf*CxHy + nar*O2 -> nco2*CO2 + nh2o*H2O + n'o2*O2
    #Razão ar-combustível real/ar-combustível estequiométrica: 
    "ϕ" => 0.0625,
    #Concentração final: 
    "[F]_f" => 1/exp(1),
#Modelos:
    "MODELOS" => "FTAS",     #Lista de modelos nos anexos. #Modelo de propriedas: PModel
#Cálculo da fração de adição de calor: 
    "Y_FRAC" => "aK",         #iK para cálculo cinético na ignição ou aK para cálculo cinético dinâmico
#Validação:
    "Validation" => "OFF"
)
if InitialData["Fluido"] == "CH4"
    InitialData["n_C"] = 1
    InitialData["n_H"] = parse(Int64, InitialData["Fluido"][end])
else
    InitialData["n_C"] = parse(Int64, InitialData["Fluido"][2])
    if InitialData["Fluido"][end-2] == 'H'
        InitialData["n_H"] = parse(Int64, InitialData["Fluido"][end-1:end])
    else
        InitialData["n_H"] = parse(Int64, InitialData["Fluido"][end])
    end
end
params = @strdict(InitialData)
sims = dict_list(InitialData)

###Tupla de tolerâncias

ϵ = (eps(1.0), eps(1.0), eps(1.0))


end
