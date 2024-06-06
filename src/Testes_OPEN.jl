using .FTOtto
using Plots

X = FTOtto.Init_Parameters(r_compr = 14, MODELOS = "FTAF", Fluido = "C4H10", ϕ = 0.01, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 0)
Y = FTOtto.Initialization(X)
FTOtto.cFTAFik(Y)
RES = FTOtto.RESULTS(Y)
FTOtto.TABLES(RES)
Y["INPUT"]["FLUID"]["m_R"]