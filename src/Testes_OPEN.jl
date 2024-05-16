using .FTOtto
using Plots

A = FTOtto.Init_Parameters(r_compr = 30.5, MODELOS = "FTAS", Fluido = "O2", ϕ = 0.1, Half_lifes = 10, Y_FRAC = "iK", Open = true, α_minimo = -180, α_maximo = 450, θ_ign = 180)

B = FTOtto.Initialization(A, FTOtto.ϵ)

plot(B["SIMUL"]["α"], B["SIMUL"]["𝕍"])