using .FTOtto

A = FTOtto.Init_Parameters(MODELOS = "FTHA", Δt_comb = 8.33e-7, Fluido = "O2")

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.FTHA(B)

FTOtto.RESULTS(B, TABLE = "ON")

B["INPUT"]["rv"]