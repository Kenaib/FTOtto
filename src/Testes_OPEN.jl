using .FTOtto
using Plots

X = FTOtto.Init_Parameters(r_compr = 13, MODELOS = "FTHA", Fluido = "O2", Half_lifes = 10, Y_FRAC = "aK", α = 0.05, q_ent = 5, Δt_comb = 0.0150042)
Y = FTOtto.Initialization(X)
FTOtto.FTHA(Y)
RES = FTOtto.RESULTS(Y)
FTOtto.TABLES(RES)
length(Y["SIMUL"]["q"])