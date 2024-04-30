using .FTOtto
using Plots

A = FTOtto.Init_Parameters(r_compr = 30.5, MODELOS = "FTAS", Fluido = "O2", ϕ = 0.1, Half_lifes = 10, Y_FRAC = "iK", α = 0.1, q_ent = 1000)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTASik(B)

RES1 = FTOtto.RESULTS(B)

X = FTOtto.Init_Parameters(r_compr = 25, MODELOS = "FTAS", Fluido = "CH4", ϕ = 0.0625, Half_lifes = 10, Y_FRAC = "aK", α = 0.1, q_ent = 1000)

Y = FTOtto.Initialization(X, FTOtto.ϵ)

FTOtto.cFTASak(Y)

RES2 = FTOtto.RESULTS(Y)

Plot1 = FTOtto.ThermoPlots(B, "y-α", Y)

FTOtto.SAVE_PLOTS(Plot_name = "y-α-Teste", Plot = Plot1)


