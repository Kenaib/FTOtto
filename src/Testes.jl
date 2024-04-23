using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 16, MODELOS = "FTAS", Δt_comb = nothing, Fluido = "O2", ϕ = 0.0625)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.TESTE(B)
B["INPUT"]