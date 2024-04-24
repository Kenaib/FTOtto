using .FTOtto
using Plots

A = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTAS", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTASik(B)

print(FTOtto.RESULTS(B, TABLE = "ON"))

D = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTHA", Δt_comb = 1.9266622625233304e-5, Fluido = "O2")

E = FTOtto.Initialization(D, FTOtto.ϵ)

FTOtto.FTHA(E)

print(FTOtto.RESULTS(E, TABLE = "ON"))

plot(E["SIMUL"]["𝕧"], E["SIMUL"]["P"], label = "FTHA")
plot!(B["SIMUL"]["𝕧"], B["SIMUL"]["P"], label = "cFTAS-iK")
