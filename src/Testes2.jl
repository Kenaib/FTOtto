using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTAS", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Half_lifes = 7)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTASik(B)

FTOtto.RESULTS(B)

#FTOtto.SAVE_SIM(Init_Data = A, Results = B, Name = (r_compr = 21, MODELOS = "FTAF", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128))
#FTOtto.SAVE_SIM(Init_Data = C, Results = D, Name = (r_compr = 21, MODELOS = "FTHA", Δt_comb = 2.2067730317404524e-5, Fluido = "O2"))

#FTOtto.SAVE_PLOTS(Plot_name = "P-α", Plot = FTOtto.ThermoPlots(D, "T-v", B))