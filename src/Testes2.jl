using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTAF", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTAFik(B)

print(FTOtto.RESULTS(B, TABLE = "ON"))

C = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTHA", Δt_comb = 2.2067730317404524e-5, Fluido = "O2")

D = FTOtto.Initialization(C, FTOtto.ϵ)

FTOtto.FTHA(D)

print(FTOtto.RESULTS(D, TABLE = "ON"))


