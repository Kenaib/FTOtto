using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTAF", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTAFik(B)

print(FTOtto.RESULTS(B, TABLE = "ON"))

C = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTHA", Δt_comb = 2.2067730317404524e-5, Fluido = "O2")

D = FTOtto.Initialization(C, FTOtto.ϵ)

FTOtto.FTHA(D)

FTOtto.RESULTS(D)

#FTOtto.SAVE_SIM(Init_Data = A, Results = B, Name = (r_compr = 21, MODELOS = "FTAF", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128))
#FTOtto.SAVE_SIM(Init_Data = C, Results = D, Name = (r_compr = 21, MODELOS = "FTHA", Δt_comb = 2.2067730317404524e-5, Fluido = "O2"))

#FTOtto.SAVE_PLOTS(Plot_name = "P-α", Plot = FTOtto.ThermoPlots(D, "T-v", B))