using .FTOtto
using Plots

#A = FTOtto.Init_Parameters(r_compr = 20, MODELOS = "FTAS", Fluido = "C4H10", ϕ = 0.0355, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 1000)

#B = FTOtto.Initialization(A, FTOtto.ϵ)

#FTOtto.cFTASik(B)

#RES1 = FTOtto.RESULTS(B)

X = FTOtto.Init_Parameters(r_compr = 18, MODELOS = "FTAF", Fluido = "C4H10", ϕ = 0.01, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 1000)

Y = FTOtto.Initialization(X, FTOtto.ϵ)

FTOtto.cFTAFik(Y)

X1 = FTOtto.Init_Parameters(r_compr = 18, MODELOS = "FTAF", Fluido = "C4H10", ϕ = 0.01, Half_lifes = 10, Y_FRAC = "aK", α = 0.05, q_ent = 1000)

Y1 = FTOtto.Initialization(X1)

FTOtto.cFTAFak(Y1)

Plot1 = FTOtto.ThermoPlots(Y, "y-α", Y1)
savefig(Plot1, "FTAFy-a-ik-ak-rv=18-phi=0.01.png")

