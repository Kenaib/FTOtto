using .FTOtto
using Plots

A = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTAS", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Half_lifes = 7)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTASik(B)

print(FTOtto.RESULTS(B, TABLE = "ON"))

D = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTHA", Δt_comb = 1.9266622625233304e-5, Fluido = "O2")

E = FTOtto.Initialization(D, FTOtto.ϵ)

FTOtto.FTHA(E)

print(FTOtto.RESULTS(E, TABLE = "ON"))

#FTOtto.SAVE_SIM(Init_Data = A, Results = B, Name = (r_compr = 21, MODELOS = "FTAS", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128))
#FTOtto.SAVE_SIM(Init_Data = D, Results = E, Name = (r_compr = 21, MODELOS = "FTHA", Δt_comb = 1.9266622625233304e-5, Fluido = "O2"))

FTOtto.SAVE_PLOTS(Plot_name = "P-v", Plot = FTOtto.ThermoPlots(E, "P-v", B))
