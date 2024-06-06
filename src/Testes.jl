using .FTOtto
using Plots
using Printf

X = FTOtto.Init_Parameters(r_compr = 16, MODELOS = "FTHA", Fluido = "O2", ϕ = 0.01, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 1000, Δt_comb = 0.0055)

Y = FTOtto.Initialization(X, FTOtto.ϵ)

FTOtto.FTHA(Y)

FTASik = FTOtto.RESULTS(Y)

X1 = FTOtto.Init_Parameters(r_compr = 16, MODELOS = "FTAS", Fluido = "C4H10",  ϕ = 0.001, Half_lifes = 10, Y_FRAC = "aK", α = 0.05, q_ent = 1000)

Y1 = FTOtto.Initialization(X1)

FTOtto.cFTASak(Y1)

FTASak = FTOtto.RESULTS(Y1)

FTOtto.TABLES(FTASik)
FTOtto.TABLES(FTASak)

Δt_FTASik = Y["INPUT"]["Δt_c"]
ntSI = FTASik["η_t"]*100
Δt_FTASak = Y1["INPUT"]["Δt_c"]
ntSA = FTASak["η_t"]*100

#Sem eficiência térmica: 

a = plot(Y["SIMUL"]["𝕧"], Y["SIMUL"]["T"], xlabel = "v [m³/kg]", ylabel = "y(α)", label = "FTAS-IK", legend=:outertopright)
plot!(a, Y1["SIMUL"]["𝕧"], Y1["SIMUL"]["T"], label = "FTAF-IK")
savefig(a, "teste")

#Com eficiência térmica: 
#a = plot(Y["SIMUL"]["𝕧"], Y["SIMUL"]["T"], xlabel = "v [m³/kg]", ylabel = "T [K] ", label = "FTAS-IK, Δt_c = "* @sprintf("%.7f", Δt_FTASik) * " s; η = " * @sprintf("%.2f", ntSI) * "%")
#plot!(a, Y1["SIMUL"]["𝕧"], Y1["SIMUL"]["T"], label = "FTAS-AK, Δt_c = "* @sprintf("%.7f", Δt_FTASak) * " s; η = " * @sprintf("%.2f", ntSA) * "%")
#savefig(a, "CNTrv=16T-v-FTAS-IK-FTAS-AK.png")