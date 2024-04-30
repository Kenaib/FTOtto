using .FTOtto
using Plots

A = FTOtto.Init_Parameters(r_compr = 30.5, MODELOS = "FTAS", Fluido = "O2", ϕ = 0.1, Half_lifes = 10, Y_FRAC = "iK", α = 0.1, q_ent = 1000)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTASik(B)

RES1 = FTOtto.RESULTS(B)

Plot1 = FTOtto.ThermoPlots(B, "y-α")

FTOtto.SAVE_PLOTS(Plot_name = "4", Plot = Plot1)



