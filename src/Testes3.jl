using .FTOtto
using Plots

using .FTOtto
using Plots

X = FTOtto.Init_Parameters(r_compr = 13, MODELOS = "FTAF", Fluido = "C4H10", ϕ = 0.0005, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 1000)

Y = FTOtto.Initialization(X, FTOtto.ϵ)

FTOtto.cFTAFik(Y)

FTASik = FTOtto.RESULTS(Y)

X1 = FTOtto.Init_Parameters(r_compr = 13, MODELOS = "FTHA", Fluido = "O2", Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 1006.38589515996, Δt_comb = 0.000148325)

Y1 = FTOtto.Initialization(X1)

FTOtto.FTHA(Y1)

FTHA = FTOtto.RESULTS(Y1)

FTOtto.TABLES(FTASik, FTHA)

logP_Ftas_ik = [log(i) for i in Y["SIMUL"]["P"]]
logv_Ftas_ik = [log(i) for i in Y["SIMUL"]["𝕧"]]
logP_FTHA = [log(i) for i in Y1["SIMUL"]["P"]]
logv_FTHA = [log(i) for i in Y1["SIMUL"]["𝕧"]]

a = plot(logv_Ftas_ik, logP_Ftas_ik, xlabel = "log(v) [m³/kg]", ylabel = "log(P) [kPa] ", label = "FTAF-AK")
plot!(a, logv_FTHA, logP_FTHA, marker=:plus, color=:purple, label = "FTHA")
Y["INPUT"]["FLUID"]["m_R"]
