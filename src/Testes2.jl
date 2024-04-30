using .FTOtto

using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 18, MODELOS = "FTAF", Fluido = "O2", ϕ = 0.0625, Half_lifes = 10, Y_FRAC = "aK", α = 0.1)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTAFak(B)

RES1 = FTOtto.RESULTS(B)

FTOtto.ThermoPlots(B, "y-α")

#FTOtto.SAVE_SIM(Init_Data = A, Results = B, Name = (r_compr = 21, MODELOS = "FTAF", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128))
#FTOtto.SAVE_SIM(Init_Data = C, Results = D, Name = (r_compr = 21, MODELOS = "FTHA", Δt_comb = 2.2067730317404524e-5, Fluido = "O2"))

FTOtto.TABLES(RES1)