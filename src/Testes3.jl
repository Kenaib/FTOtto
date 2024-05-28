using .FTOtto
using Plots

#A = FTOtto.Init_Parameters(r_compr = 20, MODELOS = "FTAS", Fluido = "C4H10", ϕ = 0.0355, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 1000)

#B = FTOtto.Initialization(A, FTOtto.ϵ)

#FTOtto.cFTASik(B)

#RES1 = FTOtto.RESULTS(B)

X = FTOtto.Init_Parameters(r_compr = 20, MODELOS = "FTAS", Fluido = "C4H10", ϕ = 0.0355, Half_lifes = 10, Y_FRAC = "aK", α = 0.05, q_ent = 1000)

Y = FTOtto.Initialization(X, FTOtto.ϵ)

FTOtto.cFTASak(Y)

RES2 = FTOtto.RESULTS(Y)

Plot1 = FTOtto.ThermoPlots(Y, "y-α")

savefig(Plot1, "y-alpha-ak-rv=18.5-phi=0.035.png")

