using .FTOtto

A = FTOtto.Init_Parameters(ϕ = 0, Δt_comb = 0)

Init = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.FTHA(Init)
